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
set DOKAN_SOURCE_URI=https://github.com/dokan-dev/dokany.git

REM Allow user to choose to use legacy dokan or not 
set USE_LEGACY_DOKAN=

REM provide legacy dokan support 
if defined USE_LEGACY_DOKAN (
  set DOKANY_VERSION=v0.7.4
  set DOKANY_VERSION_STR=0.7.4
) else (
  set DOKANY_VERSION=v1.0.0-RC2
  set DOKANY_VERSION_STR=1.0.0
)



REM ========= DO NOT EDIT BELOW THIS LINE =====================



REM don't bother if they already have a dokan installation
if defined DOKAN_ROOT (
  if exist "%DOKAN_ROOT%\Win32\Release\dokan1.lib" (
    if exist "%DOKAN_ROOT%\Win32\Release\dokanfuse1.lib" (goto :dokan_already_installed)
  )
)


REM Failed to find dokan -- ask user if they want us to build it for them
echo.
SET /P DOKAN_CONFIRM_BUILD=Dokan (DOKAN_ROOT) was not detected.  Should we install it now? (Y/n): 
if /I "%DOKAN_CONFIRM_BUILD%"=="n" exit /b 1


REM move into deps folder 
if NOT exist "deps" mkdir deps
pushd deps


REM Clone git repository and switch to DOKANY_VERSION release 
echo.
echo ==================================================
echo             CLONING DOKANY REPOSITORY (%DOKANY_VERSION%)            
echo ==================================================
REM git submodule update --init
git clone %DOKAN_SOURCE_URI% dokan >dokany-clone.log
pushd dokan
git clean -ffdx
git reset --hard %DOKANY_VERSION%
git checkout %DOKANY_VERSION%

REM upgrade legacy solution 
if defined USE_LEGACY_DOKAN (
  echo.
  echo ~~~~~ Upgrading legacy solution ~~~~~
  echo.
  cmd /c devenv "dokan.sln" /upgrade
)

REM build libraries 
echo.
echo ==================================================
echo              BUILDING DOKANY LIBRARIES             
echo ==================================================
if defined USE_LEGACY_DOKAN (
  msbuild dokan.sln /p:PlatformToolset=v140  /p:ForceImportBeforeCppTargets="%DEPS_DIR%\dokan-legacy.props" /p:Configuration=Release /p:Platform=Win32 /t:Clean,Build
) else (
  msbuild dokan.sln /p:Configuration=Release /p:Platform=Win32 /t:Clean,Build
)

REM verify necessary libraries were successfully built 
if defined USE_LEGACY_DOKAN (
  if NOT exist ".\Win32\Release\dokan.lib" goto :dokan_build_failure
  if NOT exist ".\Win32\Release\dokanfuse.lib" goto :dokan_build_failure
  copy ".\Win32\Release\dokan.lib" ".\Win32\Release\dokan1.lib"
  copy ".\Win32\Release\dokanfuse.lib" ".\Win32\Release\dokanfuse1.lib"
) else (
  if NOT exist ".\Win32\Release\dokan1.lib" goto :dokan_build_failure
  if NOT exist ".\Win32\Release\dokan1.dll" goto :dokan_build_failure
  if NOT exist ".\Win32\Release\dokanfuse1.lib" goto :dokan_build_failure
  if NOT exist ".\Win32\Release\dokanfuse1.dll" goto :dokan_build_failure
)

REM set DOKAN_ROOT environment variable 
set DOKAN_ROOT=%CD%
setx DOKAN_ROOT "%DOKAN_ROOT%"

goto :dokan_build_success



:dokan_build_success

echo.
echo ==================================================
echo      Dokan library successfully installed! 
echo ==================================================
echo.

goto :dokan_end



:dokan_build_failure

echo.
echo ==================================================
echo     Failed to build necessary Dokan library! 
echo ==================================================
echo.
exit /b 1

goto :dokan_end



:dokan_already_installed

echo.
echo ==================================================
echo            Dokan already installed
echo ==================================================
echo.
exit /b 0

goto :dokan_end



:dokan_end
popd
popd
exit /b 0
