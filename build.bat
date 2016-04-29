@ECHO OFF
REM build.bat
REM *****************************************************************************
REM Author:   Charles Munson <jetwhiz@jetwhiz.com>
REM 
REM ****************************************************************************
REM Copyright (c) 2016, Charles Munson
REM 
REM This program is free software: you can redistribute it and/or modify it
REM under the terms of the GNU Lesser General Public License as published by the
REM Free Software Foundation, either version 3 of the License, or (at your
REM option) any later version.
REM 
REM This program is distributed in the hope that it will be useful, but WITHOUT
REM ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
REM FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
REM for more details.
REM 
REM You should have received a copy of the GNU Lesser General Public License
REM along with this program.  If not, see <http://www.gnu.org/licenses/>.


REM Allow building of encfs4win 2.0
set ENCFS_MAJOR_VERSION=1
if /I "%1"=="--beta" set ENCFS_MAJOR_VERSION=2


REM Remember the PWD for encfs4win project
set PROJECT_DIR=%CD%


REM Make sure perl is installed 
perl < nul
if NOT %ERRORLEVEL% == 0 goto :no_perl


REM MSYS is required to build libgcrypt, and we don't know where it is yet 
if "%ENCFS_MAJOR_VERSION%"=="2" (
    set MSYS_BIN_DIR=C:\MinGW\msys\1.0\bin
    if NOT exist "%MSYS_BIN_DIR%\sh.exe" (
        SET /P MSYS_BIN_DIR=Please input the path to your MSYS bin directory: 
    )
    if NOT exist "%MSYS_BIN_DIR%\sh.exe" goto :no_msys
)


REM Make sure MSBUILD is available (and set up environmemt) 
set DEPS_DIR=%CD%\deps
set VCPath=%PROGRAMFILES(x86)%\MSBuild\14.0\Bin
set PATH=%PATH%;%VCPath%
set VCTargetsPath=%PROGRAMFILES(x86)%\MSBuild\Microsoft.Cpp\v4.0\V140
if NOT exist "%VCPath%\msbuild.exe" goto :no_msbuild
if NOT exist "%PROGRAMFILES(x86)%\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat" goto :no_msbuild
if not defined DevEnvDir (
    call "%PROGRAMFILES(x86)%\Microsoft Visual Studio 14.0\VC\bin\vcvars32.bat"
)



REM openssl
call build-openssl.bat
if NOT %ERRORLEVEL% == 0 goto :no_openssl


REM libgpg-error
if "%ENCFS_MAJOR_VERSION%"=="2" (
    call build-libgpgerror.bat
    if NOT %ERRORLEVEL% == 0 goto :no_libgpgerror
)


REM libgcrypt
if "%ENCFS_MAJOR_VERSION%"=="2" (
    call build-libgcrypt.bat
    if NOT %ERRORLEVEL% == 0 goto :no_libgcrypt
)


REM tinyxml2
call build-tinyxml2.bat
if NOT %ERRORLEVEL% == 0 goto :no_tinyxml2


REM dokany
call build-dokany.bat
if NOT %ERRORLEVEL% == 0 goto :no_dokany


REM (Clean,)? Build encfs 
echo.
echo ==================================================
echo                   BUILDING ENCFS             
echo ==================================================
msbuild encfs/encfs.sln /p:Configuration=Release /p:Platform=x86 /t:Clean,Build

REM verify necessary executables were successfully installed  
if NOT exist ".\encfs\Release\encfs.exe" goto :build_failure
if NOT exist ".\encfs\Release\encfsctl.exe" goto :build_failure

goto :build_success



:build_success

echo.
echo ==================================================
echo           Encfs successfully built! 
echo ==================================================
echo.

goto :end



:build_failure

echo.
echo ==================================================
echo        Failed to build necessary Encfs! 
echo ==================================================
echo.
exit /b 1

goto :end



:no_msbuild

echo.
echo ==================================================
echo   MSBuild V140 is required to build this project!
echo ==================================================
echo.
exit /b 1

goto :end



:no_msys

echo.
echo ==================================================
echo     MSYS is required to build this project!
echo ==================================================
echo.
exit /b 1

goto :end



:no_perl

echo.
echo ==================================================
echo     Perl is required to build this project!
echo ==================================================
echo.
exit /b 1

goto :end



:no_openssl

echo.
echo ==================================================
echo    OpenSSL could not be built, and is required!
echo ==================================================
echo.
exit /b 1

goto :end



:no_libgpgerror

echo.
echo ==================================================
echo  libgpg-error could not be built, and is required!
echo ==================================================
echo.
exit /b 1

goto :end



:no_libgcrypt

echo.
echo ==================================================
echo   libgcrypt could not be built, and is required!
echo ==================================================
echo.
exit /b 1

goto :end



:no_tinyxml2

echo.
echo ==================================================
echo   tinyxml2 could not be built, and is required!
echo ==================================================
echo.
exit /b 1

goto :end



:no_dokany

echo.
echo ==================================================
echo    Dokany could not be built, and is required!
echo ==================================================
echo.
exit /b 1

goto :end



:end
exit /b 0
