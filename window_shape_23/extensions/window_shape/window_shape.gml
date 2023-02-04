#define window_shape_init
/// ()
window_shape_init_raw(window_handle());
global.__ptrt_window_shape = ["window_shape"];
global.__window_shape_buffer = undefined;
global.__window_shape_buffer_alt = undefined;

#define window_shape_prepare_buffer
/// (size:int)->buffer~
var _size = argument0;
var _buf = global.__window_shape_buffer;
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
var _size = argument0;
var _buf = global.__window_shape_buffer_alt;
if (_buf == undefined) {
    _buf = buffer_create(_size, buffer_grow, 1);
    global.__window_shape_buffer_alt = _buf;
} else if (buffer_get_size(_buf) < _size) {
    buffer_resize(_buf, _size);
}
buffer_seek(_buf, buffer_seek_start, 0);
return _buf;

#define window_shape_create_polygon_from_array
/// (point_array, mode, ?count)->window_shape
var _arr = argument[0];
var _mode = argument[1];
var _count;
if (argument_count <= 2) {
    // GMS >= 2.3:
    _count = array_length(_arr) div 2;
    /*/
    _count = array_length_1d(_arr) div 2;
    //*/
} else {
    _count = argument[2];
}
var _buf = window_shape_prepare_buffer_alt(_count * 8);
var _ind = -1;
repeat (_count) {
    buffer_write(_buf, buffer_s32, _arr[++_ind]);
    buffer_write(_buf, buffer_s32, _arr[++_ind]);
}
return window_shape_create_polygon_from_buffer(_buf, _mode, _count);

#define window_shape_create_polygon_from_path
/// (path, mode)->window_shape
var _path = argument0, _mode = argument1;
var _count = path_get_number(_path);
if (_count < 3) show_error("Not enough points in a path", true);
var _ind = -1;
var _prec = 1 << path_get_precision(_path);
var _smooth = path_get_kind(_path);
var _buf = window_shape_prepare_buffer_alt(16 * _count + 8 * (_smooth ? _count * _prec : _count));
repeat (_count) {
    buffer_write(_buf, buffer_f64, path_get_point_x(_path, ++_ind));
    buffer_write(_buf, buffer_f64, path_get_point_y(_path, _ind));
}
return window_shape_create_polygon_from_path_data(_buf, _mode, path_get_closed(_path), _smooth, _prec, _count);
/*if (path_get_kind(_path)) {
    var _closed = path_get_closed(_path);
    var _last = _count - 1;
    var _prec = 1 << path_get_precision(_path);
    var _step = 1 / _prec;
    var _cx = path_get_point_x(_path, _closed ? _last : 0);
    var _cy = path_get_point_y(_path, _closed ? _last : 0);
    var _nx = path_get_point_x(_path, 0);
    var _ny = path_get_point_y(_path, 0);
    var _px, _py;
    var _buf = window_shape_prepare_buffer_alt(_count * 8 * _prec);
    repeat (_count) {
        _ind += 1;
        
        _px = _cx;
        _py = _cy;
        _cx = _nx;
        _cy = _ny;
        if (_ind == _last) {
            if (!_closed) {
                _nx = path_get_point_x(_path, _last);
                _ny = path_get_point_y(_path, _last);
            } else {
                _nx = path_get_point_x(_path, 0);
                _ny = path_get_point_y(_path, 0);
            }
        } else {
            _nx = path_get_point_x(_path, _ind + 1);
            _ny = path_get_point_y(_path, _ind + 1);
        }
        
        var _pos = 0;
        repeat (_prec) {
            // bezier curves, I'm afraid
            buffer_write(_buf, buffer_s32, 0.5 * (((_px - 2 * _cx + _nx) * _pos + 2 * (_cx - _px)) * _pos + _px + _cx));
            buffer_write(_buf, buffer_s32, 0.5 * (((_py - 2 * _cy + _ny) * _pos + 2 * (_cy - _py)) * _pos + _py + _cy));
            _pos += _step;
        }
    }
    return window_shape_create_polygon_from_buffer(_buf, _mode);
} else {
    var _buf = window_shape_prepare_buffer_alt(_count * 8);
    repeat (_count) {
        buffer_write(_buf, buffer_s32, path_get_point_x(_path, ++_ind));
        buffer_write(_buf, buffer_s32, path_get_point_y(_path, _ind));
    }
    return window_shape_create_polygon_from_buffer(_buf, _mode, _count);
}*/

#define window_shape_create_rectangles_from_surface
/// (surface, tolerance)->window_shape
var _surf = argument0, _tol = argument1;
var _width = surface_get_width(_surf);
var _height = surface_get_height(_surf);
var _buf = window_shape_prepare_buffer_alt(_width * _height * 4);
// GMS >= 2.3:
buffer_get_surface(_buf, _surf, 0);
/*/
buffer_get_surface(_buf, _surf, 0, 0, 0);
//*/
return window_shape_create_rectangles_from_rgba(_buf, _tol, _width, _height);

#define window_shape_create_rectangles_from_sprite
/// (sprite, subimg, tolerance)->window_shape
var _sprite = argument0, _subimg = argument1, _tol = argument2;
var _width = sprite_get_width(_sprite);
var _height = sprite_get_height(_sprite);
var _surf = surface_create(_width, _height);
surface_set_target(_surf);
draw_clear_alpha(c_black, 0);
// GMS >= 2.0:
gpu_set_blendmode_ext(bm_one, bm_zero);
/*/
draw_set_blend_mode_ext(bm_one, bm_zero);
//*/
draw_sprite(_sprite, _subimg, sprite_get_xoffset(_sprite), sprite_get_yoffset(_sprite));
// GMS >= 2.0:
gpu_set_blendmode(bm_normal);
/*/
draw_set_blend_mode(bm_normal);
//*/
surface_reset_target();
var _shape = window_shape_create_rectangles_from_surface(_surf, _tol);
surface_free(_surf);
return _shape;