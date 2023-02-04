@echo off
set dllPath=%~1
set solutionDir=%~2
set projectDir=%~3
set arch=%~4
set config=%~5

echo Running pre-build for %config%

where /q GmlCppExtFuncs
if %ERRORLEVEL% EQU 0 (
	echo Running GmlCppExtFuncs...
	GmlCppExtFuncs ^
	--prefix window_shape^
	--cpp "%projectDir%autogen.cpp"^
	--include "window_shape.h"^
	--struct auto^
	--gml "%solutionDir%window_shape_23/extensions/window_shape/autogen.gml"^
	%projectDir%window_shape.cpp
)