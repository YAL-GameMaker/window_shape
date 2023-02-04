@echo off
set /p ver="Version?: "
echo Uploading %ver%...
set user=yellowafterlife
set ext=gamemaker-window_shape
cmd /C itchio-butler push "window_shape (for GMS1.4).gmez" %user%/%ext%:gms1 --userversion=%ver%
cmd /C itchio-butler push "window_shape (for GMS2.2).yymp" %user%/%ext%:gms2 --userversion=%ver%
cmd /C itchio-butler push "window_shape (for GMS2.3 and GM2022+).yymps" %user%/%ext%:gms2.3 --userversion=%ver%

pause