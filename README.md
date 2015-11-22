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

## Status

I will try to keep this updated with the [EncFS project](https://github.com/vgough/encfs) 
as changes come in upstream.  

EncFS4win has been tested with the latest release of Dokan (v0.7.4), but has not yet been tested 
with the release candidates (v0.8.x).  
