#pragma once
#include "stdafx.h"
#define tiny_const_array_h

template<typename T> class tiny_const_array {
	const T* _data;
	size_t _size;
public:
	tiny_const_array() {}
	tiny_const_array(const T* data, size_t size) : _data(data), _size(size) {}
	const T* data() { return _data; }
	size_t size() { return _size; }

	T operator[] (size_t index) const { return _data[index]; }
	T& operator[] (size_t index) { return _data[index]; }
};
