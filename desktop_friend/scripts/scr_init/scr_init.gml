// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_init(){
	static ready = false;
	if (ready) exit;
	ready = true;
	
	/*instance_create_depth(0, 0, 0, obj_gmlive);
	live_code_updated = function(_name, _dname) {
		global.fresh_reload = true;
	}*/
	global.fresh_reload = false;
	//
	window_shape_init();
	window_enable_per_pixel_alpha();
}