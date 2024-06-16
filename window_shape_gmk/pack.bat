@echo off

del /Q "window-shape (for GM8.x).zip"
cmd /C 7z a "window-shape (for GM8.x).zip" window_shape.dll window_shape.cpp window_shape.gml window_shape_constants.txt

pause