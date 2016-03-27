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
set BOOST_VERSION=1.60.0
set BOOST_VERSION_STR=1_60
set MSVC_VERSION=14.0
set MSVC_VERSION_STR=vc140
set BOOST_SOURCE_URI=https://github.com/boostorg/boost.git



REM ========= DO NOT EDIT BELOW THIS LINE =====================



REM Define some important paths 
set BOOST_INSTALL_DIR=..\boost_%BOOST_VERSION_STR%_0
set BOOST_INCLUDE_DIR=%BOOST_INSTALL_DIR%\includes
set BOOST_LIBDIR=%BOOST_INSTALL_DIR%\lib32-msvc-%MSVC_VERSION%


REM don't bother if they already have a boost installation
if defined BOOST_ROOT (
  if exist "%BOOST_ROOT%\lib32-msvc-%MSVC_VERSION%\libboost_filesystem-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
    if exist "%BOOST_ROOT%\lib32-msvc-%MSVC_VERSION%\libboost_serialization-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
      if exist "%BOOST_ROOT%\lib32-msvc-%MSVC_VERSION%\libboost_system-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
        goto :boost_already_installed
      )
    )
  )
)


REM Failed to find boost -- ask user if they want us to build it for them
echo.
echo Boost (BOOST_ROOT) was not detected.  The Boost library is over 1.5 GB in size and takes a very long time to build. 
SET /P BOOST_CONFIRM_BUILD=Should we download and install it now? (y/N): 
if /I "%BOOST_CONFIRM_BUILD%" NEQ "y" exit /b 1


REM move into deps folder 
if NOT exist "deps" mkdir deps
pushd deps


REM Clone git repository and switch to BOOST_VERSION release 
REM cloned size is ~1.3 GB
echo.
echo ==================================================
echo             CLONING BOOST REPOSITORY             
echo ==================================================
REM git submodule update --init
git clone --recursive %BOOST_SOURCE_URI% boost >boost-clone.log
pushd boost
git clean -ffdx
git reset --hard boost-%BOOST_VERSION%
git checkout boost-%BOOST_VERSION%

REM build libraries (built size is ~2 GB) 
echo.
echo ==================================================
echo              BUILDING BOOST LIBRARIES             
echo ==================================================
cmd /c .\bootstrap --with-libraries=filesystem,serialization,system 
.\b2 -d+1 --with-filesystem --with-serialization --with-system headers 
.\b2 -d+1 --with-filesystem --with-serialization --with-system toolset=msvc-%MSVC_VERSION% variant=release link=static address-model=32 threading=multi

REM verify necessary libraries were successfully built 
if NOT exist ".\bin.v2\libs\filesystem\build\msvc-%MSVC_VERSION%\release\link-static\threading-multi\libboost_filesystem-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" goto :boost_build_failure
if NOT exist ".\bin.v2\libs\serialization\build\msvc-%MSVC_VERSION%\release\link-static\threading-multi\libboost_serialization-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" goto :boost_build_failure
if NOT exist ".\bin.v2\libs\system\build\msvc-%MSVC_VERSION%\release\link-static\threading-multi\libboost_system-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" goto :boost_build_failure

REM install boost 
echo.
echo ==================================================
echo              INSTALLING BOOST LIBRARIES             
echo ==================================================
.\b2 -d+1 --prefix=%BOOST_INSTALL_DIR% --with-filesystem --with-serialization --with-system --includedir=%BOOST_INCLUDE_DIR% --libdir=%BOOST_LIBDIR% toolset=msvc-%MSVC_VERSION% variant=release link=static address-model=32 threading=multi install

REM verify necessary libraries were successfully installed  
if NOT exist "%BOOST_LIBDIR%\libboost_filesystem-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
  goto :boost_build_failure)
if NOT exist "%BOOST_LIBDIR%\libboost_serialization-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
  goto :boost_build_failure)
if NOT exist "%BOOST_LIBDIR%\libboost_system-%MSVC_VERSION_STR%-mt-%BOOST_VERSION_STR%.lib" (
  goto :boost_build_failure)

REM set BOOST_ROOT environment variable 
pushd %BOOST_INSTALL_DIR%
set BOOST_ROOT=%CD%
setx BOOST_ROOT "%BOOST_ROOT%"
popd

goto :boost_build_success



:boost_build_success

echo.
echo ==================================================
echo      Boost libraries successfully installed! 
echo ==================================================
echo.

goto :boost_end



:boost_build_failure

echo.
echo ==================================================
echo         Failed to build Boost libraries
echo ==================================================
echo.
exit /b 1

goto :boost_end



:boost_already_installed

echo.
echo ==================================================
echo            Boost already installed
echo ==================================================
echo.
exit /b 0

goto :boost_end



:boost_end
popd
popd
exit /b 0
