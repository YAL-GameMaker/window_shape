// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "window_shape.h"
#define gm_extension_name "window_shape"

#if ((defined(_MSVC_LANG) && _MSVC_LANG >= 201703L) || __cplusplus >= 201703L)
#define tiny_cpp17
#endif

#define _trace // requires user32.lib;Kernel32.lib
#define _show_error // requires user32.lib;Kernel32.lib

#ifdef TINY // common things to implement
//#define tiny_memset
//#define tiny_memcpy
#define tiny_malloc
//#define tiny_dtoui3
//#define tiny_ftol2
#endif

#ifdef _trace
static constexpr char trace_prefix[] = "[" gm_extension_name "] ";
#ifdef _WINDOWS
void trace(const char* format, ...);
#else
#define trace(...) { printf("%s", trace_prefix); printf(__VA_ARGS__); printf("\n"); fflush(stdout); }
#endif
#endif

#ifdef _show_error
void show_error(const char* format, ...);
#endif


#pragma region typed memory helpers
template<typename T> T* malloc_arr(size_t count) {
	return (T*)malloc(sizeof(T) * count);
}
template<typename T> T* realloc_arr(T* arr, size_t count) {
	return (T*)realloc(arr, sizeof(T) * count);
}
template<typename T> T* memcpy_arr(T* dst, const T* src, size_t count) {
	return (T*)memcpy(dst, src, sizeof(T) * count);
}
#pragma endregion

#include "gml_ext.h"

// TODO: reference additional headers your program requires here
