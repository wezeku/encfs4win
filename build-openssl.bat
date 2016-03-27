@ECHO OFF

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
set OPENSSL_VERSION=1.0.2g
set OPENSSL_VERSION_STR=1_0_2g
set MSVC_VERSION=14.0
set MSVC_VERSION_STR=vc140

set OPENSSL_INSTALL_DIR=openssl-bin



REM ========= DO NOT EDIT BELOW THIS LINE =====================



REM don't bother if they already have a openssl installation
if defined OPENSSL_ROOT (
  if exist "%OPENSSL_ROOT%\bin\libeay32.dll" (
    if exist "%OPENSSL_ROOT%\bin\ssleay32.dll" (
      if exist "%OPENSSL_ROOT%\include" (goto :openssl_already_installed)
    )
  )
)


REM Failed to find OpenSSL -- ask user if they want us to build it for them
echo.
SET /P OPENSSL_CONFIRM_BUILD=OpenSSL (OPENSSL_ROOT) was not detected.  Should we install it now? (Y/n): 
if /I "%OPENSSL_CONFIRM_BUILD%"=="n" exit /b 1


REM move into deps folder 
if NOT exist "deps" mkdir deps
pushd deps


REM Clone git repository and switch to OPENSSL_VERSION release 
echo.
echo ==================================================
echo            CLONING OPENSSL REPOSITORY             
echo ==================================================
REM git submodule update --init
git clone https://github.com/openssl/openssl.git openssl >openssl-clone.log
pushd openssl
git clean -ffdx
git reset --hard OpenSSL_%OPENSSL_VERSION_STR%
git checkout OpenSSL_%OPENSSL_VERSION_STR%

REM build libraries 
echo.
echo ==================================================
echo             BUILDING OPENSSL LIBRARIES             
echo ==================================================
perl Configure VC-WIN32 no-asm --prefix="%OPENSSL_INSTALL_DIR%"
cmd /c ms\do_ms
nmake -f ms\ntdll.mak
nmake -f ms\ntdll.mak install

REM verify necessary libraries were successfully installed  
if NOT exist ".\%OPENSSL_INSTALL_DIR%\bin\libeay32.dll" goto :openssl_build_failure
if NOT exist ".\%OPENSSL_INSTALL_DIR%\bin\ssleay32.dll" goto :openssl_build_failure
if NOT exist ".\%OPENSSL_INSTALL_DIR%\include" goto :openssl_build_failure

REM set OPENSSL_ROOT environment variable 
pushd %OPENSSL_INSTALL_DIR%
set OPENSSL_ROOT=%CD%
setx OPENSSL_ROOT "%OPENSSL_ROOT%"
popd

goto :openssl_build_success



:openssl_build_success

echo.
echo ==================================================
echo     OpenSSL libraries successfully installed! 
echo ==================================================
echo.

goto :openssl_end



:openssl_build_failure

echo.
echo ==================================================
echo        Failed to build OpenSSL libraries
echo ==================================================
echo.
exit /b 1

goto :openssl_end



:openssl_already_installed

echo.
echo ==================================================
echo            OpenSSL already installed
echo ==================================================
echo.
exit /b 0

goto :openssl_end



:openssl_end
popd
popd
exit /b 0
