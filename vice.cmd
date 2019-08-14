java -jar ./KickAss.jar || goto :error
C:\C64\GTK3VICE-3.3-win32-r35896\x64.exe -warp disk1.d64
@exit

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
