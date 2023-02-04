if (mouse_check_button_pressed(mb_left)) {
    drag_x = display_mouse_get_x() - window_get_x();
    drag_y = display_mouse_get_y() - window_get_y();
    dragging = true;
}
if (dragging) {
    if (mouse_check_button(mb_left)) {
        window_set_position(
            display_mouse_get_x() - drag_x,
            display_mouse_get_y() - drag_y,
        )
    } else {
        dragging = false;
    }
}