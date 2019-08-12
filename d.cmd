java -jar ./KickAss.jar build_disk.asm || goto :error
::.\C64Debugger disk1.d64
C:\C64\GTK3VICE-3.3-win32-r35896\x64.exe -warp disk1.d64
@exit

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
