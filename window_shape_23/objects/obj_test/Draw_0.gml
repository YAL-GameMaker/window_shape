draw_set_font(fnt_test);
draw_set_color(c_white);
if (transparent) {
	// Windows expects pre-multiplied alpha
	var c = #889EC5;
	var rw = room_width;
	var rh = room_height;
	//var ca = mouse_x/rw;
	//draw_clear_alpha(merge_color(0, c, ca), ca);
	draw_clear_alpha(0, 0);
	
	var a1 = 0.9;
	var a2 = 0.1;
	var c1 = merge_color(c_black, c, a1);
	var c2 = merge_color(c_black, c, a2);
	draw_primitive_begin(pr_trianglestrip);
	draw_vertex_color( 0,  0, c1, a1);
	draw_vertex_color(rw,  0, c1, a1);
	draw_vertex_color( 0, rh, c2, a2);
	draw_vertex_color(rw, rh, c2, a2);
	draw_primitive_end();
}

var w = window_get_width();
var h = window_get_height();
var r = min(w, h) / 2;
var cx = w / 2;
var cy = h / 2;
text = "Try things:\n";
key = ord("0");
if (testOpt("Exit")) game_end();
if (testOpt("Default shape")) {
    window_shape_reset();
}
if (testOpt("An ellipse")) {
    window_shape_set(window_shape_create_ellipse(0, 0, w, h));
}
if (testOpt("Two ellipses?")) {
    window_shape_set(window_shape_combine(
        window_shape_create_ellipse(0, 0, w * 0.4, h),
        window_shape_create_ellipse(w * 0.6, 0, w, h),
        window_shape_operation_or
    ));
}
if (testOpt("A donut?")) {
    window_shape_set(window_shape_combine(
        window_shape_create_circle(cx, cy, r),
        window_shape_create_circle(cx, cy, r * 0.4),
        window_shape_operation_diff
    ));
}
if (testOpt("A smooth shape")) {
    window_shape_set(window_shape_create_polygon_from_path(
		pt_smooth, window_shape_polygon_mode_winding));
}
if (testOpt("An engine-specific shape")) {
    var r1 = r * 0.45;
    window_shape_set(window_shape_create_polygon_from_array([
        cx, cy,
        cx + r1, cy,
        cx + r1, cy + r - r1,
        cx, cy + r, // bot
        cx - r, cy,
        cx, cy - r,
        cx + r, cy,
        cx + r1, cy,
        cx, cy - r1,
        cx - r1, cy,
        cx, cy + r1,
    ], window_shape_polygon_mode_winding));
}
if (testOpt("A familiar shape")) {
    window_shape_set(window_shape_combine(
        window_shape_create_polygon_from_path(pt_dino_shape, window_shape_polygon_mode_winding),
        window_shape_create_polygon_from_path(pt_dino_eye, window_shape_polygon_mode_winding),
        window_shape_operation_diff
    ));
}
drawText(5, 5, text);

text = "More things:\n";
key = ord("A");

var _star = -1;
if (testOpt("Star, alternate")) _star = window_shape_polygon_mode_alternate;
if (testOpt("Star, winding")) _star = window_shape_polygon_mode_winding;
if (_star != -1) {
    var f = 30;
    var n = 5;
    var arr = [];
    repeat (5) {
        array_push(arr,
            cx + lengthdir_x(r, f),
            cy + lengthdir_y(r, f),
        );
        f += 360/5*2;
    }
    window_shape_set(window_shape_create_polygon_from_array(arr, _star));
}

if (testOpt("Sprite shape (slow!)")) {
    var s = window_shape_create_rectangles_from_sprite(spr_oh_no, 0, 200);
    window_shape_shift(s, random(w - sprite_get_width(s)), random(h - sprite_get_height(s)));
    window_shape_set(s);
}

if (testOpt("Moving shape")) {
    peep_enabled = true;
}
if (peep_enabled) {
    var _peep_x = peep_x;
    var _peep_y = peep_y;
    var _dir = current_time / 5;
    var _len = r - 80;
    peep_x = round(cx + lengthdir_x(_len, _dir));
    peep_y = round(cy + lengthdir_y(_len, _dir));
    window_shape_shift(peep, peep_x - _peep_x, peep_y - _peep_y);
    window_shape_set_nc(peep);
    /*text += "Hit: " + string(window_shape_contains_point(peep,
        display_mouse_get_x() - window_get_x(),
        display_mouse_get_y() - window_get_y(),
    )) + "\n";*/
}

if (testOpt("Transformed shape")) {
    var _circle = window_shape_create_circle(100, 100, 100);
    var _transf = window_shape_transform(_circle, 1, -0.2, -0.2, 1, 50, 50);
    window_shape_set(_transf);
    window_shape_destroy(_circle);
}

if (testOpt("XOR")) {
    var f = 45;
    var _shape = window_shape_create_empty();
    var r1 = r * 0.5;
    repeat (3) {
        window_shape_concat(_shape, window_shape_create_circle(
            cx + lengthdir_x(r1, f),
            cy + lengthdir_y(r1, f),
            r1,
        ), window_shape_operation_xor);
        f += 120;
    }
    window_shape_set(_shape);
}

if (testOpt("Uh oh")) {
    var t0 = current_time;
    var r1 = point_distance(0, 0, w/2, h/2);
    for (;;) {
        var t = (current_time - t0) / 3000;
        if (t > 2) break;
        if (t < 0.5) {
            window_shape_set(window_shape_create_circle(cx, cy, r1 * (0.5 + 0.5 * cos(t * pi * 2))));
        } else if (t < 1.5) {
            window_shape_set(window_shape_create_empty());
        } else {
            window_shape_set(window_shape_create_circle(cx, cy, r1 * (0.5 + 0.5 * cos((t - 1) * pi * 2))));
        }
    }
    window_shape_reset();
}

if (testOpt(
	transparent
	? "Per-pixel alpha enabled"
	: "Enable per-pixel alpha"
)) {
	transparent = true;
	window_enable_per_pixel_alpha();
}

drawText(w/2, 5, text);
