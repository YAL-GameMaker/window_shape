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
peep = window_shape_create_circle(0, 0, 80);
peep_x = 0;
peep_y = 0;
peep_enabled = false;