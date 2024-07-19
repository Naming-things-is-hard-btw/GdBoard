extends Control

var editing = false
var index = -1
func _input(event):
	if event is InputEventMouseMotion:
		if editing:
			position += event.relative
			position.x = clamp(position.x, 0, get_parent().get_parent().size.x)
			position.y = clamp(position.y, 0, get_parent().get_parent().size.y)
			get_parent().get_parent().pointupdate(index, self)
		pass

func c_gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			editing = true
			get_parent().get_parent().editstart()
			pass
		if not event.pressed:
			editing = false
			get_parent().get_parent().editstop()
			pass
	pass

func tan_edit():
	get_parent().get_parent().editstart()

func tan_stop():
	get_parent().get_parent().editstop()

func l_tangent(node):
	var e = (global_position.y - node.global_position.y) / (get_parent().get_parent().size.y / 4)
	get_parent().get_parent().set_tangent_l(index,-e)
	pass

func r_tangent(node):
	var e = (global_position.y - node.global_position.y) / (get_parent().get_parent().size.y / 4)
	get_parent().get_parent().set_tangent_r(index,-e)
	pass
