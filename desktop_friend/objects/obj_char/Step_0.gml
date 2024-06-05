//live_auto_call
if (global.fresh_reload) {
	global.fresh_reload = false;
	event_perform(ev_create, 0);
}

if (mouse_check_button_released(mb_right)) {
	if (show_question("Time to go home?")) {
		game_end();
	}
}

time += 1;

var _width = display_get_width();
var _height = display_get_height();
var _mouse_x = display_mouse_get_x();
var _mouse_y = display_mouse_get_y();
var _mouse_moved = _mouse_x != last_mouse_x || _mouse_y != last_mouse_y;
if (_mouse_moved) {
	mouse_still_time = 0;
} else mouse_still_time += 1;
last_mouse_x = _mouse_x;
last_mouse_y = _mouse_y;
var _mouse_over = position_meeting(_mouse_x, _mouse_y, id);

var _clickable = clickable;
clickable = dragging || (_mouse_over && mouse_still_time >= 10);
if (time >= 10) {
	window_set_topmost(true);
	window_set_clickthrough(!clickable);
	window_set_taskbar_button_visible(false);
}

//
if (mouse_check_button_pressed(mb_left)) {
	drag_x = _mouse_x - x;
	drag_y = _mouse_y - y;
	dragging = true;
}

// states
var _idle = false;
if (dragging) {
	if (mouse_check_button(mb_left)) {
		x = _mouse_x - drag_x;
		y = _mouse_y - drag_y;
		//if (x != xprevious) image_xscale = sign(x - xprevious);
		walking = 0;
		idle_time = 0;
		happy_time = 0;
	} else {
		dragging = false;
	}
} else if (happy_time > 0) {
	happy_time -= 1;
	post_happy = true;
} else if (walking > 0) {
	if (mp_linear_step(walk_x, walk_y, walk_speed, false)) {
		// we're there!
		walking = 0;
	}
} else {
	_idle = true;
	idle_time += 1;
	var _idle_time = idle_time;
	
	// faster to walk off after being "petted"
	if (post_happy) _idle_time *= 2;
	
	// curious about right-clicks when far away
	var _force = keyboard_check_direct(2) && point_distance(x, y, _mouse_x, _mouse_y) > 300;
	
	if (_force || _idle_time > 180 && random(100) < 1 + _idle_time / 1000) {
		var _run = post_happy || random(5) < 1;
		post_happy = false;
		walking = _run ? 2 : 1;
		if (_force) {
			// approach the mouse carefully
			var _dir = point_direction(x, y, _mouse_x, _mouse_y);
			var _dist = random_range(100, 200);
			walk_x = _mouse_x - lengthdir_x(_dist, _dir);
			walk_y = _mouse_y - lengthdir_y(_dist, _dir);
			_run = random(1000) < point_distance(x, y, walk_x, walk_y);
			walking = _run ? 2 : 1;
		} else repeat (40) {
			// TODO: you could query the available displays to be able to walk off to a different one
			walk_x = random_range(40, _width - 40);
			walk_y = random_range(60, _height - 80);
			
			// we want a point that's not too close and not too far
			var _dist = point_distance(x, y, walk_x, walk_y);
			if (_run) {
				if (_dist > 400 && _dist < 900) break;
			} else {
				if (_dist > 200 && _dist < 600) break;
			}
		}
		
		var _dir = point_direction(x, y, walk_x, walk_y);
		var _dx = lengthdir_x(1, _dir);
		
		image_xscale = _dx > 0 ? 1 : -1;
		
		// this isn't quite how you make movement on vertical axis slower, but it'll do
		if (_run) {
			walk_speed = 3 + abs(_dx * 4);
		} else {
			walk_speed = 1 + abs(_dx * 3);
		}
		walk_speed *= random_range(0.8, 1.2);
	}
}
if (!_idle) idle_time = 0;

// rub
if (dragging) {
	rub_time = 0;
	time_since_rub = 0;
} else if (_mouse_moved && _mouse_over) {
	if (rub_time == 0) {
		rub_time = time;
	}
	time_since_rub = 0;
	if (time - rub_time >= 30) {
		rub_time = 0;
		happy_time = max(happy_time, random_range(120, 240));
		walking = 0;
	}
} else if (rub_time > 0) {
	time_since_rub += 1;
	if (time_since_rub >= 60) {
		rub_time = 0;
	}
}

//
var _wx = round(x) - room_width/2;
var _wy = round(y) - room_height/2;
if (window_get_x() != _wx || window_get_y() != _wy) {
	window_set_position(_wx, _wy);
}

// animation control
if (dragging) {
	sprite_index = spr_carry;
}
else if (happy_time > 0) {
	sprite_index = spr_happy;
}
else if (walking > 0) {
	sprite_index = walking > 1 ? spr_run : spr_walk;
}
else {
	sprite_index = spr_idle;
}
//
//image_alpha = position_meeting(display_mouse_get_x(), display_mouse_get_y(), id)?1:0.5;