@ECHO OFF
SETLOCAL
REM build-easyloggingpp.bat
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
set VERSION=v9.80
set VERSION_STR=v9.80
set SOURCE_URI=https://github.com/easylogging/easyloggingpp.git



REM ========= DO NOT EDIT BELOW THIS LINE =====================



REM set up some globally-constant settings
set SRC_DIR_NAME=easyloggingpp
set INSTALL_DIR=%CD%\deps\%SRC_DIR_NAME%\


REM don't bother if they already have an installation
if defined INSTALL_DIR (
    if exist "%INSTALL_DIR%\src\easylogging++.h" (goto :already_installed)
)


REM Failed to find easyloggingpp -- ask user if they want us to build it for them
echo.
SET /P CONFIRM_BUILD=easylogging++ was not detected.  Should we install it now? (Y/n): 
if /I "%CONFIRM_BUILD%"=="n" exit /b 1


REM move into deps folder 
if NOT exist "deps" mkdir deps
pushd deps


REM Clone git repository and switch to VERSION release 
echo.
echo ==================================================
echo    CLONING EASYLOGGINGPP REPOSITORY (%VERSION%)            
echo ==================================================
git clone %SOURCE_URI% %SRC_DIR_NAME% > %SRC_DIR_NAME%-clone.log
pushd %SRC_DIR_NAME%
git clean -ffdx
git reset --hard %VERSION%
git checkout %VERSION%

REM Patch bug in toFile 
git apply ../easyloggingpp.patch

REM verify necessary libraries were successfully installed  
if NOT exist "%INSTALL_DIR%\src\easylogging++.h" goto :build_failure



goto :build_success



:build_success

echo.
echo ==================================================
echo    easylogging++ library successfully installed! 
echo ==================================================
echo.

goto :build_end



:build_failure

echo.
echo ==================================================
echo  Failed to build necessary easylogging++ library! 
echo ==================================================
echo.
exit /b 1

goto :build_end



:already_installed

echo.
echo ==================================================
echo          easylogging++ already installed
echo ==================================================
echo.
exit /b 0

goto :build_end



:build_end
popd
popd
exit /b 0
