java -jar ./KickAss.jar || goto :error
.\C64Debugger -wait 100 -autorundisk -autojmp  -vicesymbols build_disk.vs -d64 disk1.d64
@exit

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
