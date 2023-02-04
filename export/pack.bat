@echo off

if not exist "window_shape-for-GMS1\window_shape\Assets\datafiles" mkdir "window_shape-for-GMS1\window_shape\Assets\datafiles"
cmd /C copyre ..\window_shape.gmx\extensions\window_shape.extension.gmx window_shape-for-GMS1\window_shape.extension.gmx
cmd /C copyre ..\window_shape.gmx\extensions\window_shape window_shape-for-GMS1\window_shape
cmd /C copyre ..\window_shape.gmx\datafiles\window_shape.html window_shape-for-GMS1\window_shape\Assets\datafiles\window_shape.html
cd window_shape-for-GMS1
cmd /C 7z a window_shape-for-GMS1.7z *
move /Y window_shape-for-GMS1.7z "../window_shape (for GMS1.4).gmez"
cd ..

if not exist "window_shape-for-GMS2\extensions" mkdir "window_shape-for-GMS2\extensions"
if not exist "window_shape-for-GMS2\datafiles" mkdir "window_shape-for-GMS2\datafiles"
if not exist "window_shape-for-GMS2\datafiles_yy" mkdir "window_shape-for-GMS2\datafiles_yy"
cmd /C copyre ..\window_shape_yy\extensions\window_shape window_shape-for-GMS2\extensions\window_shape
cmd /C copyre ..\window_shape_yy\datafiles\window_shape.html window_shape-for-GMS2\datafiles\window_shape.html
cmd /C copyre ..\window_shape_yy\datafiles_yy\window_shape.html.yy window_shape-for-GMS2\datafiles_yy\window_shape.html.yy
cd window_shape-for-GMS2
cmd /C 7z a window_shape-for-GMS2.zip *
move /Y window_shape-for-GMS2.zip "../window_shape (for GMS2.2).yymp"
cd ..

if not exist "window_shape-for-GMS2.3+\extensions" mkdir "window_shape-for-GMS2.3+\extensions"
if not exist "window_shape-for-GMS2.3+\datafiles" mkdir "window_shape-for-GMS2.3+\datafiles"
if not exist "window_shape-for-GMS2.3+\scripts\window_shape_ctr" mkdir "window_shape-for-GMS2.3+\scripts\window_shape_ctr"
cmd /C copyre ..\window_shape_23\extensions\window_shape window_shape-for-GMS2.3+\extensions\window_shape
cmd /C copyre ..\window_shape_23\datafiles\window_shape.html window_shape-for-GMS2.3+\datafiles\window_shape.html
cmd /C copyre ..\window_shape_23\scripts\window_shape_ctr window_shape-for-GMS2.3+\scripts\window_shape_ctr
cd window_shape-for-GMS2.3+
cmd /C 7z a window_shape-for-GMS2.3+.zip *
move /Y window_shape-for-GMS2.3+.zip "../window_shape (for GMS2.3 and GM2022+).yymps"
cd ..

pause