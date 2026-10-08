@echo off
setlocal
cd /d "%~dp0"
set /p URL=<app-url.txt
set "DEST=%LOCALAPPDATA%\SmartCalculator"
if not exist "%DEST%" mkdir "%DEST%"
copy /y "%~dp0icon.ico" "%DEST%\icon.ico" >nul
set "BROWSER="
if exist "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if exist "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe" set "BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe" set "BROWSER=%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe"
if not defined BROWSER (
  echo Microsoft Edge or Google Chrome was not found.
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$s=(New-Object -ComObject WScript.Shell).CreateShortcut([Environment]::GetFolderPath('Desktop')+'\Smart Calculator.lnk');$s.TargetPath='%BROWSER%';$s.Arguments='--app=%URL%';$s.IconLocation='%DEST%\icon.ico';$s.Description='Smart Calculator';$s.Save()"
echo.
echo Done. "Smart Calculator" icon was added to your Desktop.
pause
