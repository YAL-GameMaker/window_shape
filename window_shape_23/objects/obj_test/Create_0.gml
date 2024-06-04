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
        peep_enabled = false;
        return true;
    } else return false;
}
drawText = function(_x, _y, _text) /*=>*/ {
	var _color = draw_get_color();
	var _alpha = draw_get_alpha();
	static _dx = [1, 0, -1, 0];
	static _dy = [0, -1, 0, 1];
	draw_set_color(c_black);
	draw_set_alpha(_alpha * 0.3);
	for (var i = 0; i < 4; i++) {
		draw_text(_x + 1 + _dx[i]*2, _y + 1 + _dy[i]*2, _text);
	}
	draw_set_alpha(_alpha * 0.5);
	for (var i = 0; i < 4; i++) {
		draw_text(_x + 1 + _dx[i], _y + 1 + _dy[i], _text);
	}
	draw_set_alpha(_alpha * 0.7);
	draw_text(_x + 1, _y + 1, _text);
	draw_set_color(_color);
	draw_set_alpha(_alpha);
	draw_text(_x, _y, _text);
}
peep = window_shape_create_circle(0, 0, 80);
peep_x = 0;
peep_y = 0;
peep_enabled = false;
transparent = false;