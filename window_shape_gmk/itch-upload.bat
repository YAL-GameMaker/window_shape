@echo off
set /p ver="Version?: "
echo Uploading %ver%...
set user=yellowafterlife
set ext=gamemaker-window-shape
cmd /C itchio-butler push "window-shape (for GM8.x).zip" %user%/%ext%:gm8 --userversion=%ver%
cmd /C itchio-butler push "window_shape.gm81" %user%/%ext%:gm8demo --userversion=%ver%

pause