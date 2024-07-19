extends Control
class_name menu

func clear():
	for a in get_children():
		a.queue_free()
	pass

func add_int(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/number/number.tscn").instantiate()
	inst._setup(target, var_name, true , display_name, display_icon, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_float(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/number/number.tscn").instantiate()
	inst._setup(target, var_name, false , display_name, display_icon, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector3(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector/vector.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector3i(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector/vector.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector4(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector4/vector4.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector4i(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector4/vector4.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector2(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector2d/vector2d.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_vector2i(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/vector2d/vector2d.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_color(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/color/color.tscn").instantiate()
	inst._setup(target, var_name, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_bool(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/boolean/bool.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_string(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/types/text/text.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass


func add_texture(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/texture_selector/texture_selector.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_button(display_name : String, display_icon : Texture2D, button_name : String, callable : Callable):
	var inst = preload("res://core/menu/button/button.tscn").instantiate()
	inst._setup(display_name, button_name, callable, display_icon)
	add_child.call_deferred(inst)
	pass

func add_curve(display_name : String, display_icon : Texture2D, var_name : String, target : Object, default_value, update_callable : Callable):
	var inst = preload("res://core/menu/curve/curve.tscn").instantiate()
	inst._setup(target, var_name, display_icon, display_name, update_callable, default_value)
	add_child.call_deferred(inst)
	pass

func add_custom(control : Control):
	add_child.call_deferred(control)
	pass
