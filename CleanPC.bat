@echo off
setlocal enabledelayedexpansion

:: === Auto-update configuration ===
set "current_version=1.0.0.0"
set "version_url=https://raw.githubusercontent.com/BlackBullNetwork/Cleaner-Script/main/latest_version.txt"
set "script_url=https://raw.githubusercontent.com/BlackBullNetwork/Cleaner-Script/main/CleanPC.bat"
set "curl_path=%SystemRoot%\System32\curl.exe"

echo Checking for updates...

:: Download latest version number
"%curl_path%" -s -o "%temp%\latest_version.txt" "%version_url%"
if errorlevel 1 (
    echo Failed to download version info.
    goto mainmenu
)
if not exist "%temp%\latest_version.txt" (
    echo Version info file missing.
    goto mainmenu
)

:: Read latest version into variable
set /p latest_version=<"%temp%\latest_version.txt"
:: Trim trailing spaces just in case
for /f "tokens=* delims= " %%a in ("!latest_version!") do set "latest_version=%%a"

echo Current version: !current_version!
echo Latest version:  !latest_version!

if "!latest_version!"=="!current_version!" (
    echo You are already running the latest version.
    goto mainmenu
) else (
    echo New version available! Downloading update...
    "%curl_path%" -s -o "%temp%\BlackBullCleaner_new.bat" "%script_url%"
    if errorlevel 1 (
        echo Failed to download updated script.
        goto mainmenu
    )
    if exist "%temp%\BlackBullCleaner_new.bat" (
        echo Update downloaded.
        echo Copying new script over current script...
        copy /Y "%temp%\BlackBullCleaner_new.bat" "%~f0" >nul
        if errorlevel 1 (
            echo Failed to update script file. Close any open editors or permissions may be blocking it.
            goto mainmenu
        )
        echo Update successful! Please restart the script now.
        exit /b
    ) else (
        echo Update file not found after download.
        goto mainmenu
    )
)

:mainmenu
cls
title BlackBull PC Cleaner 💻✨
color 0A

:MENU
cls
echo ======================= V!current_version!
echo     BlackBull Clean-Up Menu
echo ================================
echo [1] Run MRT (Malware Scan)
echo [2] Update all programs
echo [3] Clear Temp Files
echo [4] Empty Recycle Bin
echo [5] Flush DNS Cache
echo [6] Clean Windows Update Cache
echo [7] Run SFC (System File Checker)
echo [8] Run DISM (Fix Corrupted System)
echo [9] Improve FPS / Gaming Mode
echo [10] Exit
echo.
set /p choice=Choose wisely: 

if "%choice%"=="1" goto MRT
if "%choice%"=="2" goto WINGET
if "%choice%"=="3" goto CLEARTEMP
if "%choice%"=="4" goto EMPTYBIN
if "%choice%"=="5" goto FLUSHDNS
if "%choice%"=="6" goto CLEANWUCACHE
if "%choice%"=="7" goto SFC
if "%choice%"=="8" goto DISM
if "%choice%"=="9" exit
if "%choice%"=="10" goto FPSBOOST
goto MENU

:MRT
echo Running MRT...
start mrt
pause
goto MENU

:WINGET
echo Updating all apps with winget...
winget upgrade --all
pause
goto MENU

:CLEARTEMP
echo Cleaning temp files...
del /s /f /q %temp%\*
del /s /f /q C:\Windows\Temp\*
echo Temp files deleted!
pause
goto MENU

:EMPTYBIN
echo Emptying Recycle Bin...
%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -Command "Clear-RecycleBin -Force"
pause
goto MENU

:FLUSHDNS
echo Flushing DNS cache...
ipconfig /flushdns
pause
goto MENU

:CLEANWUCACHE
echo Stopping Windows Update Service...
net stop wuauserv
net stop bits
echo Deleting SoftwareDistribution folder...
rd /s /q C:\Windows\SoftwareDistribution
echo Starting Windows Update Service...
net start wuauserv
net start bits
pause
goto MENU

:SFC
echo Running System File Checker...
sfc /scannow
pause
goto MENU

:DISM
echo Running DISM Restore Health...
DISM /Online /Cleanup-Image /RestoreHealth
pause
goto MENU

:FPSBOOST
cls
echo ================================
echo     FPS Boost Menu
echo ================================
echo [1] Install FPS Boost
echo [2] Reset FPS Boost
echo [3] Disable Windows Notifications / Focus Assist
echo [4] Set High Performance Power Plan
echo [5] Disable Xbox Game Bar & DVR
echo [6] Reset Network (Release/Renew, Winsock reset)
echo [7] Clean GPU Cache & Temp Files (NVIDIA)
echo [8] Clear Clipboard
echo [9] Disable Windows Tips
echo [10] Adjust Visual Effects for Best Performance
echo [11] Back to Main Menu
echo.
set /p fpschoice=Choose an option: 

if "%fpschoice%"=="1" goto FPSINSTALL
if "%fpschoice%"=="2" goto FPSRESET
if "%fpschoice%"=="3" goto DISABLENOTIFS
if "%fpschoice%"=="4" goto HIGHPERF
if "%fpschoice%"=="5" goto DISABLEXBOX
if "%fpschoice%"=="6" goto RESETNETWORK
if "%fpschoice%"=="7" goto CLEANGPUCACHE
if "%fpschoice%"=="8" goto CLEARCLIPBOARD
if "%fpschoice%"=="9" goto DISABLETIPS
if "%fpschoice%"=="10" goto VISUALEFFECTS
if "%fpschoice%"=="11" goto MENU
goto FPSBOOST

:FPSINSTALL
echo Applying FPS Boost tweaks...
:: Stop unnecessary services
%SystemRoot%\System32\sc.exe stop "SysMain"
%SystemRoot%\System32\sc.exe config "SysMain" start= disabled
%SystemRoot%\System32\sc.exe stop "DiagTrack"
%SystemRoot%\System32\sc.exe config "DiagTrack" start= disabled
%SystemRoot%\System32\sc.exe stop "WSearch"
%SystemRoot%\System32\sc.exe config "WSearch" start= disabled
%SystemRoot%\System32\sc.exe stop "Fax"
%SystemRoot%\System32\sc.exe config "Fax" start= disabled

:: Disable transparency effects & animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 0 /f

:: Disable Windows Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f

:: Disable Microsoft Edge background processes & startup boost
reg add "HKCU\Software\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v AllowTabPreloading /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v StartupBoostEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v BackgroundModeEnabled /t REG_DWORD /d 0 /f

echo FPS boost applied! Some changes require restart.
pause
goto FPSBOOST

:FPSRESET
echo Reverting FPS Boost tweaks...
:: Re-enable services
%SystemRoot%\System32\sc.exe config "SysMain" start= auto
%SystemRoot%\System32\sc.exe start "SysMain"
%SystemRoot%\System32\sc.exe config "DiagTrack" start= auto
%SystemRoot%\System32\sc.exe start "DiagTrack"
%SystemRoot%\System32\sc.exe config "WSearch" start= delayed-auto
%SystemRoot%\System32\sc.exe start "WSearch"
%SystemRoot%\System32\sc.exe config "Fax" start= demand

:: Re-enable transparency effects & animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f

:: Re-enable Windows Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f

:: Remove Edge restrictions
reg delete "HKCU\Software\Policies\Microsoft\MicrosoftEdge" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f

echo FPS boost reverted! Some changes require restart.
pause
goto FPSBOOST

:DISABLENOTIFS
echo Disabling Windows Notifications and Focus Assist...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v NOC_GLOBAL_SETTING_TOASTS_ENABLED /t REG_DWORD /d 0 /f
echo Notifications disabled.
pause
goto FPSBOOST

:HIGHPERF
echo Setting High Performance Power Plan...
powercfg /setactive SCHEME_MIN
echo High Performance power plan set.
pause
goto FPSBOOST

:DISABLEXBOX
echo Disabling Xbox Game Bar and Game DVR...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\GameBar" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 0 /f

%SystemRoot%\System32\sc.exe stop "XblGameSave"
%SystemRoot%\System32\sc.exe config "XblGameSave" start= disabled
%SystemRoot%\System32\sc.exe stop "XboxGipSvc"
%SystemRoot%\System32\sc.exe config "XboxGipSvc" start= disabled

echo Xbox Game Bar and DVR disabled.
pause
goto FPSBOOST

:RESETNETWORK
echo Resetting Network (release/renew IP, winsock, IP reset)...
ipconfig /release
ipconfig /renew
netsh winsock reset
netsh int ip reset
echo Network reset complete. Restart recommended.
pause
goto FPSBOOST

:CLEANGPUCACHE
echo Cleaning NVIDIA GPU cache and temp files...
del /s /q "%LOCALAPPDATA%\NVIDIA\GLCache\*" >nul 2>&1
del /s /q "%LOCALAPPDATA%\NVIDIA\DXCache\*" >nul 2>&1
echo GPU cache cleaned.
pause
goto FPSBOOST

:CLEARCLIPBOARD
echo Clearing Clipboard...
echo off | clip
echo Clipboard cleared.
pause
goto FPSBOOST

:DISABLETIPS
echo Disabling Windows Tips...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
echo Windows Tips disabled.
pause
goto FPSBOOST

:VISUALEFFECTS
echo Adjusting Visual Effects for best performance...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
echo Visual effects adjusted.
pause
goto FPSBOOST
