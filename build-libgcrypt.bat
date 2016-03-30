@ECHO OFF
SETLOCAL
REM build-libgcrypt.bat
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


REM versioning variables 
set VERSION=1.6.5
set VERSION_STR=1.6.5
set SOURCE_URI=git://git.gnupg.org/libgcrypt.git



REM ========= DO NOT EDIT BELOW THIS LINE =====================



REM set up some globally-constant settings
set SRC_DIR_NAME=libgcrypt
set INSTALL_DIR=%CD%\deps\%SRC_DIR_NAME%\install-dir


REM don't bother if they already have an installation
if defined INSTALL_DIR (
  if exist "%INSTALL_DIR%\bin\libgcrypt-20.dll" (
    if exist "%INSTALL_DIR%\lib\libgcrypt.dll.a" (
      if exist "%INSTALL_DIR%\include\gcrypt.h" (goto :already_installed)
    )
  )
)


REM Failed to find libgcrypt -- ask user if they want us to build it for them
echo.
SET /P CONFIRM_BUILD=libgcrypt was not detected.  Should we install it now? (Y/n): 
if /I "%CONFIRM_BUILD%"=="n" exit /b 1


REM move into deps folder 
if NOT exist "deps" mkdir deps
pushd deps


REM Clone git repository and switch to VERSION release 
REM   must check out code in lf line-ending mode for MSYS support 
echo.
echo ==================================================
echo           CLONING LIBGCRYPT REPOSITORY             
echo ==================================================
git clone %SOURCE_URI% %SRC_DIR_NAME% > %SRC_DIR_NAME%-clone.log
pushd %SRC_DIR_NAME%
git config core.autocrlf false
git config core.eol lf
git clean -ffdx
git reset --hard libgcrypt-%VERSION_STR%
git checkout libgcrypt-%VERSION_STR%

REM build libraries 
echo.
echo ==================================================
echo           BUILDING LIBGCRYPT LIBRARIES             
echo ==================================================
cmd /c %MSYS_BIN_DIR%\sh.exe --login -i "%PROJECT_DIR%\build-libgcrypt.sh"


REM verify necessary libraries were successfully installed  
if NOT exist "%INSTALL_DIR%\bin\libgcrypt-20.dll" goto :build_failure
if NOT exist "%INSTALL_DIR%\lib\libgcrypt.dll.a" goto :build_failure
if NOT exist "%INSTALL_DIR%\include\gcrypt.h" goto :build_failure


goto :build_success



:build_success

echo.
echo ==================================================
echo    libgcrypt libraries successfully installed! 
echo ==================================================
echo.

goto :build_end



:build_failure

echo.
echo ==================================================
echo       Failed to build libgcrypt libraries
echo ==================================================
echo.
popd
popd
exit /b 1

goto :build_end



:already_installed

echo.
echo ==================================================
echo           libgcrypt already installed
echo ==================================================
echo.
exit /b 0

goto :build_end



:build_end
popd
popd
exit /b 0
