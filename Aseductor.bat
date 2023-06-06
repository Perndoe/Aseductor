@echo off

::Download Aseprite Source code
echo Insert link of Aseprite version you want to compile:

timeout /t 2 /nobreak >nul
start https://github.com/aseprite/aseprite/releases/

set /p input="> "
powershell -Command "Invoke-WebRequest %input% -OutFile %USERPROFILE%\Downloads\Compressed\aseprite.zip"
@echo on

::Extract Source code
powershell Expand-Archive %USERPROFILE%\Downloads\Compressed\aseprite.zip -DestinationPath %USERPROFILE%\Downloads\Compressed\Aseprite

::Call Developer Command Prompt
call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat" -arch=x64
@echo on

::Copy core files
cd C:\
md "aseprite"\"build"
xcopy "%USERPROFILE%\Downloads\Compressed\Skia Windows" "C:\deps\" /E
xcopy "%USERPROFILE%\Downloads\Compressed\Aseprite" "C:\aseprite\" /E

cd C:\aseprite\build

::Build Aseprite
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DLAF_BACKEND=skia -DSKIA_DIR=C:\deps\skia -DSKIA_LIBRARY_DIR=C:\deps\skia\out\Release-x64 -DSKIA_LIBRARY=C:\deps\skia\out\Release-x64\skia.lib -G Ninja ..

::Export build
ninja aseprite

pause >nul