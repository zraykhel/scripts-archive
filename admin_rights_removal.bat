REM Short cmd script to identify last logged on user and remove them from the local Administrators group
REM Can be used with remote management tools that run as SYSTEM to revoke local admin permissions from domain users

for /f "tokens=3" %%A in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI" /v LastLoggedOnUser') do ( 
    for /f "tokens=2 delims=\" %%B in ("%%A") do set "CurrentUser=%%B" 
) 
 
net localgroup "Administrators" %CurrentUser% /delete

shutdown /r /t 300 /c "Computer will be restarted in 5 minutes! Please save documents"
