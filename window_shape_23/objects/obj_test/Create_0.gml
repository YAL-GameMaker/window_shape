window_shape_init();

dragging = false;
drag_x = 0;
drag_y = 0;
text = "";
key = -1;
testOpt = function(_text) /*=>*/ {
    var _key = key++;
    text += "[" + chr(_key) + "] " + _text + "\n";
    if (keyboard_check_pressed(_key)) {
        return true;
    } else return false;
}
testOptShape = function(_text) /*=>*/ {
	if (testOpt(_text)) {
		peep_enabled = false;
        return true;
	} else return false;
}
drawText = function(_x, _y, _text) /*=>*/ {
	if (transparent) {
		var _color = draw_get_color();
		draw_set_color(#889EC5);
		draw_rectangle(_x - 2, _y, _x + string_width(_text) + 2, _y + string_height(_text), false);
		draw_set_color(_color);
		// and don't you dare modify the alpha of that underlay
		gpu_set_colorwriteenable(1, 1, 1, 0);
		draw_text(_x, _y, _text);
		gpu_set_colorwriteenable(1, 1, 1, 1);
		exit;
	}
	draw_text(_x, _y, _text);
}
peep = window_shape_create_circle(0, 0, 80);
peep_x = 0;
peep_y = 0;
peep_enabled = false;
transparent = false;
chroma_hole = false;
