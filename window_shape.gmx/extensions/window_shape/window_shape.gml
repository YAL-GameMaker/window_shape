#define window_shape_init
/// ()
/* GMS < 1:
window_shape_init_dll();
/*/
global.__ptrt_window_shape = ["window_shape"];
global.__window_shape_buffer = undefined;
global.__window_shape_buffer_alt = undefined;
//*/
window_shape_init_1();

// GMS >= 1:
#define window_shape_prepare_buffer
/// (size:int)->buffer~
var _size; _size = argument0;
var _buf; _buf = global.__window_shape_buffer;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__window_shape_buffer = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;

#define window_shape_prepare_buffer_alt
/// (size:int)->buffer~
var _size; _size = argument0;
var _buf; _buf = global.__window_shape_buffer_alt;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__window_shape_buffer_alt = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;
// this CC block starts in window_shape_init! */

#define window_shape_create_polygon_from_path
/// (path, mode)->window_shape
var _path, _mode; _path = argument0; _mode = argument1
var _count; _count = path_get_number(_path);
if (_count < 3) show_error("Not enough points in a path", true);
var _ind; _ind = -1;
var _prec; _prec = 1 << path_get_precision(_path);
var _smooth; _smooth = path_get_kind(_path);
// GMS >= 1:
var _buf; _buf = window_shape_prepare_buffer_alt(16 * _count);
repeat (_count) {
    buffer_write(_buf, buffer_f64, path_get_point_x(_path, ++_ind));
    buffer_write(_buf, buffer_f64, path_get_point_y(_path, _ind));
}
return window_shape_create_polygon_from_path_data(_buf, _mode, path_get_closed(_path), _smooth, _prec, _count);
/*/
var _list; _list = ds_list_create();
repeat (_count) {
    _ind += 1;
    ds_list_add(_list, path_get_point_x(_path, _ind))
    ds_list_add(_list, path_get_point_y(_path, _ind))
}
return window_shape_create_polygon_from_path_array(_list, _mode, path_get_closed(_path), _smooth, _prec, _count);
//*/

#define window_shape_create_rectangles_from_surface
/// (surface, tolerance)->window_shape
var _surf, _tol; _surf = argument0; _tol = argument1
var _width; _width = surface_get_width(_surf);
var _height; _height = surface_get_height(_surf);
var _buf; _buf = window_shape_prepare_buffer_alt(_width * _height * 4);
/* GMS >= 2.3:
buffer_get_surface(_buf, _surf, 0);
/*/
buffer_get_surface(_buf, _surf, 0, 0, 0);
//*/
return window_shape_create_rectangles_from_rgba(_buf, _tol, _width, _height);

#define window_shape_create_rectangles_from_sprite
/// (sprite, subimg, tolerance)->window_shape
var _sprite, _subimg, _tol; _sprite = argument0; _subimg = argument1; _tol = argument2
var _width; _width = sprite_get_width(_sprite);
var _height; _height = sprite_get_height(_sprite);
var _surf; _surf = surface_create(_width, _height);
surface_set_target(_surf);
draw_clear_alpha(c_black, 0);
/* GMS >= 2.0:
gpu_set_blendmode_ext(bm_one, bm_zero);
/*/
draw_set_blend_mode_ext(bm_one, bm_zero);
//*/
draw_sprite(_sprite, _subimg, sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite));
/* GMS >= 2.0:
gpu_set_blendmode(bm_normal);
/*/
draw_set_blend_mode(bm_normal);
//*/
surface_reset_target();
var _shape; _shape = window_shape_create_rectangles_from_surface(_surf, _tol);
surface_free(_surf);
return _shape;