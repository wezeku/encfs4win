; encfs4win installer 
 
 
; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "encfs"
!define PRODUCT_VERSION "1.10.1-RC3"
!define PRODUCT_PUBLISHER "CEMi4"
 
SetCompressor lzma
 
 
 
!include "MUI2.nsh"
 
; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "..\..\encfs-bin\encfs4win.ico"
 
; Welcome page
!insertmacro MUI_PAGE_WELCOME
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
!insertmacro MUI_PAGE_FINISH
 
; Language files
!insertmacro MUI_LANGUAGE "English"





; Product details 

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "..\..\encfs-bin\encfs-installer.exe"
InstallDir "$PROGRAMFILES\encfs"
ShowInstDetails show





; Installer sections 

Section -SETTINGS
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
SectionEnd

Section "VC++ Redist v120" SEC01
  File "..\..\encfs-bin\vc_redist-120_x86.exe"
  ExecWait "$INSTDIR\vc_redist-120_x86.exe /install /quiet"
SectionEnd

Section "VC++ Redist v140" SEC02
  File "..\..\encfs-bin\vc_redist-140_x86.exe"
  ExecWait "$INSTDIR\vc_redist-140_x86.exe /install /quiet"
SectionEnd

Section "Dokany v1.0" SEC03
  File "..\..\encfs-bin\DokanSetup_1.0.0RC2.exe"
  ExecWait "$INSTDIR\DokanSetup_1.0.0RC2.exe /install /quiet"
SectionEnd

Section "encfs" SEC04
  SectionIn RO
  
  # Install files
  File "Release\encfs.exe"
  File "Release\encfsctl.exe"
  File "$%OPENSSL_ROOT%\bin\libeay32.dll"
  File "$%OPENSSL_ROOT%\bin\ssleay32.dll"
  
  # Write uninstaller registry keys
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\encfs" "DisplayName" "encfs4win"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\encfs" "UninstallString" "$INSTDIR\uninstall.exe"
  
  # Create uninstaller
  writeUninstaller "$INSTDIR\uninstall.exe"
  
  # Cleanup
  Delete $INSTDIR\vc_redist-120_x86.exe
  Delete $INSTDIR\vc_redist-140_x86.exe
  Delete $INSTDIR\DokanSetup_1.0.0RC2.exe
SectionEnd

LangString DESC_SEC01 ${LANG_ENGLISH} "Microsoft Visual C++ Redistributable 2013"
LangString DESC_SEC02 ${LANG_ENGLISH} "Microsoft Visual C++ Redistributable 2015"
LangString DESC_SEC03 ${LANG_ENGLISH} "Dokany FUSE tools (v1.0)"
LangString DESC_SEC04 ${LANG_ENGLISH} "Required encfs binaries"

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} $(DESC_SEC01)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} $(DESC_SEC02)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC03} $(DESC_SEC03)
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC04} $(DESC_SEC04)
!insertmacro MUI_FUNCTION_DESCRIPTION_END





; Uninstaller

section "Uninstall"  
  SetShellVarContext all
  RMDir /r "$INSTDIR"
  Delete $INSTDIR\uninstall.exe
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\encfs"
sectionEnd
