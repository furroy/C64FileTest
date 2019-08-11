java -jar ./KickAss.jar load_assets.asm  || goto :error
.\C64Debugger disk1.d64
exit

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
