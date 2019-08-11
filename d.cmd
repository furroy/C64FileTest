java -jar ./KickAss.jar load_assets.asm  || goto :error
.\C64Debugger -autorundisk -vicesymbols load_assets.vs disk1.d64
exit

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
