//live_auto_call
if (!variable_instance_exists(id, "dragging")) {
	scr_init();
	//
	x = window_get_x() - room_width / 2;
	y = window_get_y() - room_height / 2;
	show_debug_message("first-time")
}
show_debug_message("create")

dragging = false;
drag_x = 0;
drag_y = 0;

sprite_index = spr_idle;

walking = 0;
walk_x = 0;
walk_y = 0;
walk_speed = 0;

last_mouse_x = 0;
last_mouse_y = 0;
mouse_still_time = 0;
clickable = false;

time = 0;

time_since_rub = 0;
rub_time = 0;
happy_time = 0;
idle_time = 0;
post_happy = false;