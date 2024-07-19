extends Panel

func _gui_input(event):
	$"..".c_gui_input(event)
	pass



func _on_mouse_entered():
	add_theme_stylebox_override("panel", preload("res://core/menu/curve/point/point_focus.tres"))
	pass


func _on_mouse_exited():
	add_theme_stylebox_override("panel", preload("res://core/menu/curve/point/point_clear.tres"))
	pass
