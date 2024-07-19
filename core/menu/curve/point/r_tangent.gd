extends Control


var editing = false
func _input(event):
	if event is InputEventMouseMotion:
		if editing:
			$"..".position += event.relative
			owner.r_tangent(self)
		pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			editing = true
			owner.tan_edit()
			pass
		if not event.pressed:
			editing = false
			owner.tan_stop()
			pass
	pass
