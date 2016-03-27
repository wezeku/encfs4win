# encfs4win - Windows port of EncFS 

## About

EncFS4win is a revival of the original encfs4win project, but has been brought 
up-to-date with recent changes done to the EncFS project.  The original encfs4win 
was based on EncFS v1.7.4, which was shown to have some [security issues](https://defuse.ca/audits/encfs.htm). 
[Updates to EncFS](https://github.com/vgough/encfs) have been done recently to fix many of these issues, and the goal of 
this project is to port these modernizations to Windows. 

EncFS provides an encrypted filesystem in user-space. It runs in userspace,
using the [Dokan library](https://github.com/dokan-dev/dokany) for the filesystem interface. EncFS is open source
software, licensed under the LGPL.

EncFS encrypts individual files, by translating all requests for the virtual
EncFS filesystem into the equivalent encrypted operations on the raw
filesystem.

For more info, see:

 - The excellent [encfs manpage](encfs/encfs.pod)
 - The technical overview in [DESIGN.md](DESIGN.md)

## Installing

Installation is as simple as a few clicks!  Simply download the latest encfs4win installer from [encfs4win/releases](https://github.com/jetwhiz/encfs4win/releases) (encfs4win-installer.exe) and run it.  

The installer contains everything needed to run encfs on Windows, including the encfs executables, OpenSSL libraries, and all necessary MS Visual C++ libraries. It will also automatically install the Dokan library (if it is not already installed). 

## Building

Encfs4win has a few dependencies: 

* [Visual Studio 2015](https://www.visualstudio.com/en-us/downloads/download-visual-studio-vs.aspx) - For building the project 
* [Dokan library](https://github.com/dokan-dev/dokany) - Handles FUSE portion of software.  You can use either v0.7.4 or v1.0, though versions before v1.0 should use the USE_LEGACY_DOKAN preprocessor definition. 
* [Boost library](https://github.com/boostorg/boost) - We currently use the latest (v1.60.0) for our binaries
* [OpenSSL library](https://github.com/openssl/openssl) - Always use the latest version (currently v1.0.2g).  Note that you must have Perl installed in order to build OpenSSL!

### Automated version

Encfs4win now comes with a fully-automated build tool called "build.bat", located in the root directory. This tool will automatically download, build and install Dokan, Boost and OpenSSL, before finally building encfs and rlog.  Look for "encfs.exe" and "encfsctl.exe" in the encfs\Release folder after building is finished. 

The automated tool will also check to see if any of these prerequisites are already installed (by looking for the DOKAN_ROOT, BOOST_ROOT and OPENSSL_ROOT environment variables).  If found, it will use the installed version and skip over that prerequisite. 

### Manual version

You can also choose to handle some or all of the prerequisites yourself.  After the above dependencies have been installed and built, simply open the encfs4win solution (encfs/encfs.sln) and build the solution.  Note that you must have the environment variables DOKAN_ROOT, BOOST_ROOT and OPENSSL_ROOT pointing to your Dokan, Boost and OpenSSL installations, respectively (otherwise you will need to modify the solution to point to your installations).  

This will result in encfs.exe, encfsctl.exe and the rlog binaries being built and placed in the encfs\Release directory. 

## Environment

Encfs4win works on: 

* Windows 10
* Windows 8 and 8.1
* Windows Server 2012
* Windows 7

## Status

I will try to keep this updated with the [EncFS project](https://github.com/vgough/encfs) 
as changes come in upstream.  

EncFS4win has been tested with the original release of Dokan (v0.7.x) as well as the latest Dokan (v1.x.x).  
If building with v0.7.x or earlier, be sure to add the preprocessor definition "USE_LEGACY_DOKAN" for legacy support. 

## Credits

Special thanks to [vgough/encfs](https://github.com/vgough/encfs) and [freddy77/encfs4win](https://github.com/freddy77/encfs4win) for establishing the groundwork that made this project possible! 
