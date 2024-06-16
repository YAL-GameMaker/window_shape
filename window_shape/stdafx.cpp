// stdafx.cpp : source file that includes just the standard includes
// window_shape.pch will be the pre-compiled header
// stdafx.obj will contain the pre-compiled type information

#include "stdafx.h"
#include <strsafe.h>
#ifdef tiny_dtoui3
#include <intrin.h>
#endif

#if _WINDOWS
// http://computer-programming-forum.com/7-vc.net/07649664cea3e3d7.htm
extern "C" int _fltused = 0;
#endif

// TODO: reference any additional headers you need in STDAFX.H
// and not in this file
#ifdef _trace
#ifdef _WINDOWS
// https://yal.cc/printf-without-standard-library/
void trace(const char* pszFormat, ...) {
	char buf[1024 + sizeof(trace_prefix)];
	wsprintfA(buf, "%s", trace_prefix);
	va_list argList;
	va_start(argList, pszFormat);
	wvsprintfA(buf + sizeof(trace_prefix) - 1, pszFormat, argList);
	va_end(argList);
	DWORD done;
	auto len = strlen(buf);
	buf[len] = '\n';
	buf[++len] = 0;
	WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buf, (DWORD)len, &done, NULL);
}
#endif
#endif

#ifdef _show_error
#ifdef _WINDOWS
// https://yal.cc/printf-without-standard-library/
void show_error(const char* pszFormat, ...) {
	char buf[1024];
	wsprintfA(buf, "%s", trace_prefix);
	va_list argList;
	va_start(argList, pszFormat);
	wvsprintfA(buf + sizeof(trace_prefix) - 1, pszFormat, argList);
	va_end(argList);
	auto len = strlen(buf);
	buf[len] = '\n';
	buf[++len] = 0;
	MessageBoxA(0, buf, gm_extension_name, MB_OK | MB_ICONERROR);
}
#endif
#endif

#pragma warning(disable: 28251 28252)

#ifdef tiny_memset
#pragma function(memset)
void* __cdecl memset(void* _Dst, _In_ int _Val,_In_ size_t _Size) {
	auto ptr = static_cast<uint8_t*>(_Dst);
	while (_Size) {
		*ptr++ = _Val;
		_Size--;
	}
	return _Dst;
}
#endif

#ifdef tiny_memcpy
#pragma function(memcpy)
void* memcpy(void* _Dst, const void* _Src, size_t _Size) {
	auto src8 = static_cast<const uint64_t*>(_Src);
	auto dst8 = static_cast<uint64_t*>(_Dst);
	for (; _Size > 32; _Size -= 32) {
		*dst8++ = *src8++;
		*dst8++ = *src8++;
		*dst8++ = *src8++;
		*dst8++ = *src8++;
	}
	for (; _Size > 8; _Size -= 8) *dst8++ = *src8++;
	//
	auto src1 = (const uint8_t*)(src8);
	auto dst1 = (uint8_t*)(dst8);
	for (; _Size != 0; _Size--) *dst1++ = *src1++;
	return _Dst;
}
#endif

#ifdef tiny_malloc
void* __cdecl malloc(size_t _Size) {
	return HeapAlloc(GetProcessHeap(), 0, _Size);
}
void* __cdecl realloc(void* _Block, size_t _Size) {
	auto heap = GetProcessHeap();
	void* result;
	if (_Block == nullptr) {
		// unlike the CRT realloc, HeapReAlloc won't Alloc if a block is NULL
		result = HeapAlloc(heap, HEAP_ZERO_MEMORY, _Size);
	} else {
		result = HeapReAlloc(heap, HEAP_ZERO_MEMORY, _Block, _Size);
	}
	return result;
}
void __cdecl free(void* _Block) {
	HeapFree(GetProcessHeap(), 0, _Block);
}
#endif

#ifdef tiny_dtoui3
// https:/stackoverflow.com/a/55011686/5578773
extern "C" unsigned int _dtoui3(const double x) {
	return (unsigned int)_mm_cvttsd_si32(_mm_set_sd(x));
}
#endif

#if defined(tiny_ftol2) && (INTPTR_MAX == INT32_MAX)
// silly solutions for 32-bit problems
extern "C" int64_t _ftol2(const double x) {
	// https://stackoverflow.com/questions/17035464/a-fast-method-to-round-a-double-to-a-32-bit-int-explained
	int64_t result;
	result = (int)x;
	/*__asm {
		fld x
		fistp result
	}*/
	return result;
}
#endif

#pragma warning(default: 28251 28252)
