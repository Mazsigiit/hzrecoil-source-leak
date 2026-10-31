@echo off
setlocal
cd /d "%~dp0"
where cargo >nul 2>nul
if errorlevel 1 (
  echo Rust es Visual Studio C++ Build Tools szukseges.
  pause
  exit /b 1
)
cargo test -p hzrecoil-core --locked
if errorlevel 1 exit /b 1
cargo build -p hzrecoil-desktop --release --locked
if errorlevel 1 exit /b 1
if not exist Release mkdir Release
copy /Y "target\release\hzrecoil-desktop.exe" "Release\hzRecoil.exe" >nul
if errorlevel 1 exit /b 1
if exist "target\release\*.dll" for %%F in (target\release\*.dll) do copy /Y "%%F" "Release\" >nul
if not exist "Release\WebView2Loader.dll" (
  for /D %%D in (target\release\build\webview2-com-sys-*) do (
    if exist "%%D\out\x64\WebView2Loader.dll" copy /Y "%%D\out\x64\WebView2Loader.dll" "Release\" >nul
  )
)
echo Kesz: Release\hzRecoil.exe
exit /b 0
