@echo off & setLocal EnableDelayedExpansion

:: Set the video formats to search for
set video_formats="-key1 .mkv -key2 .mp4 -key3 .avi"

:: End Edit DO NOT TOUCH ANYTHING BELOW THIS POINT UNLESS YOU KNOW WHAT YOUR DOING!

TITLE C0nw0nk - Directory TV Season ordering

echo Input the Directory or Path you want to correctly order for example C:\path or you can use \\NAS\STORAGE\PATH
set /p "plex_folder="

echo Input the season Number for example for 1st season : 01
set /p "input_season_number="

set root_path="%~dp0"

set /a fileNum = 1
set "comd=aws iam create-group %video_formats:"=%"
for /F "tokens=3*" %%p in ("%comd%") do set "tokens=%%q"
set n=0
set "key="
for %%a in (%tokens:-=%) do (
	if not defined key (
		set key=%%a
	) else (
		set /A n+=1
		set "token[!n!]=%%a"
		set "key="
	)
)
for /l %%i in (1,1,%n%) do (
	echo Enumerating all !token[%%i]!s under "%plex_folder:"=%"
::start powershell code
echo cd "%plex_folder:"=%" >"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace ",","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "^!","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "^","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace ":","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace ";","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "@","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "$","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "'","" } >>"%root_path:"=%%~n0.ps1"
echo Dir ^| >>"%root_path:"=%%~n0.ps1"
echo Where-Object { $_.Name -match "\.(!token[%%i]:.=!)x?$" } ^| >>"%root_path:"=%%~n0.ps1"
echo Rename-Item -NewName { $_.Name -replace "#","" } >>"%root_path:"=%%~n0.ps1"
::end powershell code
powershell -ExecutionPolicy Unrestricted -File "%root_path:"=%%~n0.ps1" "%*" -Verb runAs
del "%root_path:"=%%~n0.ps1"

	for /r "%plex_folder:"=%" %%f in (*!token[%%i]!) do (
		echo."%%~nf" | findstr /C:"S%input_season_number%E">nul && (
			echo found
		) || (
			echo not found
			rem echo filename %%~nf fileextension %%~xf
			cd "%plex_folder:"=%"
			if !fileNum! LSS 10 (
				echo Renaming "%%~dpnf%%~xf"
				echo to
				echo "%plex_folder:"=%\S%input_season_number%E0!fileNum! %%~nf%%~xf"
				ren "%%~dpnf%%~xf" "S%input_season_number%E0!fileNum! %%~nf%%~xf"
			) else (
				echo Renaming "%%~dpnf%%~xf"
				echo to
				echo "%plex_folder:"=%\S%input_season_number%E!fileNum! %%~nf%%~xf"
				ren "%%~dpnf%%~xf" "S%input_season_number%E!fileNum! %%~nf%%~xf"
			)
			set /a fileNum += 1
		)
	)
)

pause

exit
