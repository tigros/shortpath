@echo off
REM A batch file to shorten long PATH environment variable by using short names.
Setlocal EnableDelayedExpansion EnableExtensions

set pkey="HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment"
call :shortenpath %pkey%
echo %tpath%
rem DO NOT use setx path, it is limited to 1024 chars!
reg add %pkey% /f /v Path /t REG_SZ /d "%tpath%" 

set pkey="HKEY_CURRENT_USER\Environment"
call :shortenpath %pkey%
echo %tpath%
reg add %pkey% /f /v Path /t REG_SZ /d "%tpath%" 

rem Broadcast the change
powershell -command "& {$md=\"[DllImport(`\"user32.dll\"\",SetLastError=true,CharSet=CharSet.Auto)]public static extern IntPtr SendMessageTimeout(IntPtr hWnd,uint Msg,UIntPtr wParam,string lParam,uint fuFlags,uint uTimeout,out UIntPtr lpdwResult);\"; $sm=Add-Type -MemberDefinition $md -Name NativeMethods -Namespace Win32 -PassThru;$result=[uintptr]::zero;$sm::SendMessageTimeout(0xffff,0x001A,[uintptr]::Zero,\"Environment\",2,5000,[ref]$result)}"

call :shortenlocalpath
echo %tpath%
endlocal && set path=%tpath%

exit /b

:shortenpath
    set tpath=
    set semi=

    for /F "usebackq skip=2 tokens=2*" %%A IN (`reg query %1 /v Path`) do (
        set mypath=%%B
        set mypath=!mypath: =æ!     &rem Alt-145
        set mypath=!mypath:^)=Æ!    &rem Alt-146

        for %%N in (!mypath!) do (
            set afolder=%%N
            set afolder=!afolder:æ= !
            set afolder=!afolder:Æ=^)!
            call :shorten "!afolder!"
        )
    )

    exit /b

:shortenlocalpath
    set tpath=
    set semi=

    set mypath=%path%
    set mypath=!mypath: =æ!     &rem Alt-145
    set mypath=!mypath:^)=Æ!    &rem Alt-146

    for %%N in (!mypath!) do (
        set afolder=%%N
        set afolder=!afolder:æ= !
        set afolder=!afolder:Æ=^)!
        call :shorten "!afolder!"
    )

    exit /b
    
:shorten
    set tpath=%tpath%%semi%%~s1
    set semi=;
    exit /b
