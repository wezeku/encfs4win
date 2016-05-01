
#include <string>
#include "i18n.h"

#ifndef IDC_STATIC
#define IDC_STATIC (-1)
#endif

#define IDR_MANIFEST                            1
#define IDD_ABOUTBOX                            103
#define IDD_MAIN                                104
#define IDC_MYICON                              105
#define IDI_MAIN                                108
#define IDD_DRIVE                               110
#define IDD_OPTIONS                             111
#define IDD_PASSWORD                            113
#define IDD_PREFERENCES                         115
#define IDC_CHKPARANOIA                         1001
#define IDC_DIR                                 1004
#define IDC_CMBDRIVE                            1005
#define IDC_PWD1                                1009
#define IDC_PWD2                                1010
#define IDC_CHKSTARTUP                          1011
#define IDC_PASSWORD                            1011
#define IDC_CHKOPEN                             1012


extern HINSTANCE hFuseDllInstance;
#define hInst hFuseDllInstance

std::tstring GetExistingDirectory(HWND hwnd, LPCTSTR title = NULL, LPCTSTR caption = NULL);
bool GetPassword(HWND hwnd, TCHAR *pass, size_t len);
char SelectFreeDrive(HWND hwnd);
static inline bool YesNo(HWND hwnd, const TCHAR *msg) { return MessageBox(hwnd, msg, _T("EncFS"), MB_YESNO | MB_ICONQUESTION) == IDYES; }
bool FillFreeDrive(HWND combo);
