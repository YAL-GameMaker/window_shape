/// @author YellowAfterlife

#include "stdafx.h"

// @dllg:docname window_shape window_shape

dllg gml_id<window_shape> window_shape_create_empty() {
	return CreateRectRgn(0, 0, 0, 0);
}
dllg gml_id<window_shape> window_shape_create_rectangle(int x1, int y1, int x2, int y2) {
	return CreateRectRgn(x1, y1, x2, y2);
}
dllg gml_id<window_shape> window_shape_create_round_rectangle(int x1, int y1, int x2, int y2, int w, int h) {
	return CreateRoundRectRgn(x1, y1, x2, y2, w, h);
}
dllg gml_id<window_shape> window_shape_create_ellipse(int x1, int y1, int x2, int y2) {
	return CreateEllipticRgn(x1, y1, x2, y2);
}
dllg gml_id<window_shape> window_shape_create_circle(int x, int y, int rad) {
	return CreateEllipticRgn(x - rad, y - rad, x + rad, y + rad);
}

///
enum class window_shape_polygon_mode {
	alternate = 1,
	winding = 2,
};
dllg gml_id<window_shape> window_shape_create_polygon_from_buffer(gml_buffer b, int mode, int count = -1) {
	static_assert(sizeof(POINT) == 8);
	static_assert(offsetof(POINT, x) == 0);
	static_assert((int)window_shape_polygon_mode::alternate == ALTERNATE);
	static_assert((int)window_shape_polygon_mode::winding == WINDING);
	if (count == -1) count = b.tell() / 8;
	return CreatePolygonRgn((POINT*)b.data(), count, mode);
}
/// ~
dllg gml_id<window_shape> window_shape_create_polygon_from_path_data(gml_buffer b, int mode, bool closed, bool smooth, int precision, int count) {
	struct GmlPathPoint { double x, y; };
	static_assert(sizeof(GmlPathPoint) == 16);

	auto in = (GmlPathPoint*)b.data();
	auto points = (POINT*)(in + count);
	auto out = points;
	if (!smooth) {
		if (b.size() < sizeof(GmlPathPoint) * count + sizeof(POINT) * count) return 0;
		for (int i = 0; i < count; i++, in++, out++) {
			out->x = (int)in->x;
			out->y = (int)in->y;
		}
		return CreatePolygonRgn(points, count, mode);
	}
	if (b.size() < sizeof(GmlPathPoint) * count + sizeof(POINT) * precision * count) return 0;
	auto step = 1. / (double)precision;
	int last = count - 1;
	auto curr = &in[closed ? last : 0];
	auto next = &in[0];
	auto found = 0;
	for (int i = 0; i < count; i++) {
		auto prev = curr;
		curr = next;
		if (i == last) {
			next = &in[closed ? 0 : last];
		} else {
			next = &in[i + 1];
		}

		auto pos = 0.;
		for (int k = 0; k < precision; k++) {
			#define X(x) out->x = (int)(0.5f * (((prev->x - 2. * curr->x + next->x) * pos + 2. * (curr->x - prev->x)) * pos + prev->x + curr->x));
			X(x);
			X(y);
			#undef X
			// trace("%d: i=%d p=%d x=%d y=%d", found++, i, (int)(pos * 1000.), out->x, out->y);
			out++;
			pos += step;
		}
	}
	return CreatePolygonRgn(points, count * precision, mode);
}

inline void window_shape_create_rectangles_from_rgba_1(window_shape result, int y, int x1, int x2) {
	auto tmp = CreateRectRgn(x1, y, x2, y + 1);
	CombineRgn(result, result, tmp, RGN_OR);
	DeleteObject(tmp);
}
dllg gml_id<window_shape> window_shape_create_rectangles_from_rgba(gml_buffer b, int tolerance, int width, int height) {
	int count = width * height;
	struct rgba { uint8_t r, g, b, a; };
	auto ptr = (rgba*)b.data();
	auto result = window_shape_create_empty();
	for (int y = 0; y < height; y++) {
		int start = -1, x;
		for (x = 0; x < width; x++) {
			auto px = *ptr++;
			if (px.a <= tolerance) {
				if (start >= 0) {
					window_shape_create_rectangles_from_rgba_1(result, y, start, x);
					start = -1;
				}
			} else {
				if (start < 0) start = x;
			}
		}
		if (start >= 0) {
			window_shape_create_rectangles_from_rgba_1(result, y, start, x);
		}
	}
	return result;
}

dllg gml_id<window_shape> window_shape_duplicate(gml_id<window_shape> shape) {
	auto result = window_shape_create_empty();
	if (CombineRgn(result, shape, result, RGN_COPY) == ERROR) {
		DeleteObject(result);
		result = (window_shape)0;
	}
	return result;
}

dllg void window_shape_shift(gml_id<window_shape> shape, int x, int y) {
	OffsetRgn(shape, x, y);
}
dllg gml_id<window_shape> window_shape_transform(gml_id<window_shape> shape, float m11, float m12, float m21, float m22, float dx, float dy) {
	auto size = GetRegionData(shape, 0, NULL);
	auto data = (RGNDATA*)malloc(size);
	if (GetRegionData(shape, size, data) == 0) return 0;
	XFORM tm;
	tm.eM11 = m11;
	tm.eM12 = m12;
	tm.eM21 = m21;
	tm.eM22 = m22;
	tm.eDx = dx;
	tm.eDy = dy;
	return ExtCreateRegion(&tm, size, data);
}

///
enum class window_shape_operation {
	copy = 5,
	diff = 4,
	and = 1,
	or = 2,
	xor = 3,
};
dllg gml_id<window_shape> window_shape_combine(gml_id_destroy<window_shape> shape1, gml_id_destroy<window_shape> shape2, int op) {
	static_assert((int)window_shape_operation::copy == RGN_COPY);
	static_assert((int)window_shape_operation::diff == RGN_DIFF);
	static_assert((int)window_shape_operation::and  == RGN_AND);
	static_assert((int)window_shape_operation::or   == RGN_OR);
	static_assert((int)window_shape_operation::xor  == RGN_XOR);
	auto result = window_shape_create_empty();
	if (CombineRgn(result, shape1, shape2, op) == ERROR) {
		DeleteObject(result);
		result = (window_shape)0;
	}
	DeleteObject(shape1);
	DeleteObject(shape2);
	return result;
}
dllg gml_id<window_shape> window_shape_combine_nc(gml_id<window_shape> shape1, gml_id<window_shape> shape2, int op) {
	auto result = window_shape_create_empty();
	if (CombineRgn(result, shape1, shape2, op) == ERROR) {
		DeleteObject(result);
		result = (window_shape)-1;
	}
	return result;
}

dllg bool window_shape_concat(gml_id<window_shape> dest, gml_id<window_shape> shape, int op) {
	auto result = CombineRgn(dest, dest, shape, op) != ERROR;
	DeleteObject(shape);
	return result;
}
dllg bool window_shape_concat_nc(gml_id<window_shape> dest, gml_id<window_shape> shape, int op) {
	return CombineRgn(dest, dest, shape, op) != ERROR;
}

dllg bool window_shape_contains_point(gml_id<window_shape> shape, int x, int y) {
	return PtInRegion(shape, x, y);
}
dllg bool window_shape_contains_rectangle(gml_id<window_shape> shape, int x1, int y1, int x2, int y2) {
	RECT rect;
	rect.left = x1;
	rect.right = x2;
	rect.top = y1;
	rect.bottom = y2;
	return RectInRegion(shape, &rect);
}

static HWND hwnd;
const bool want_redraw = false; // redraws anyway? Go figure
dllg void window_shape_set(gml_id_destroy<window_shape> shape) {
	SetWindowRgn(hwnd, shape, want_redraw);
}
dllg void window_shape_set_nc(gml_id<window_shape> shape) {
	shape = window_shape_duplicate(shape);
	SetWindowRgn(hwnd, shape, want_redraw);
}
dllg void window_shape_reset() {
	SetWindowRgn(hwnd, NULL, want_redraw);
}
dllg void window_shape_destroy(gml_id_destroy<window_shape> shape) {
	DeleteObject(shape);
}

dllx void window_shape_init_raw(void* _hwnd) {
	hwnd = (HWND)_hwnd;
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved) {
	if (ul_reason_for_call == DLL_PROCESS_ATTACH) {
		hwnd = 0;
	}
	/*switch (ul_reason_for_call) {
		case DLL_PROCESS_ATTACH:
		case DLL_PROCESS_DETACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
	}*/
	return TRUE;
}
