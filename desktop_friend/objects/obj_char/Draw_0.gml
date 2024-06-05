//live_auto_call
// shadow:
draw_set_alpha(0.5);
draw_set_color(c_black);

var _sr = 25;
var _x = xstart;
var _y = ystart;
var _angle = image_angle;
if (dragging) {
	_y -= 5;
	//_angle += 10;
	_sr = 20;
}


var _sw = _sr;
var _sh = _sr * 0.3;
var _sx = xstart;
var _sy = ystart + 60;
draw_ellipse(
	_sx - _sw, _sy - _sh,
	_sx + _sw, _sy + _sh,
	false
)
draw_set_alpha(1);
draw_set_color(c_white);

if (clickable) {
	shader_set(sh_fog_premult);
	var l = 2;
	for (var d = 0; d < 360; d += 45) {
		draw_sprite_ext(sprite_index, image_index,
			_x + lengthdir_x(l, d),
			_y + lengthdir_y(l, d),
			image_xscale, image_yscale, _angle,
			#20A3EA, image_alpha
		);
	}
	shader_reset();
}
// self:
draw_sprite_ext(sprite_index, image_index,
	_x, _y,
	image_xscale, image_yscale, _angle,
	image_blend, image_alpha
);
