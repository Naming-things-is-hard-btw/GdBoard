extends Control

@export var line : Line2D
@export var points : Control
var current_value

func update(value):
	current_value = value
	if value is Curve:
		line.clear_points()
		var amount : float = 100.0
		for a in range(0,amount):
			line.add_point(Vector2(a * (size.x/amount), size.y -  (value.sample(a/amount) * size.y)  ))
			pass
		if not owner.editing:
			for a in points.get_children():
				a.queue_free()
			for a in range(value.point_count):
				var pos = value.get_point_position(a)
				pos.y = 1 - pos.y
				var inst = preload("res://core/menu/curve/point/point.tscn").instantiate()
				points.add_child(inst)
				inst.position = pos * size
				inst.index = a
				pass
		pass
	pass

func pointupdate(idx, obj):
	var value = owner.B_object.get(owner.variable_name) as Curve
	if not value: return
	if remove:
		if current_value != null:
			remove = false
			editstop()
			value.remove_point(idx)
			owner.on_value_changed(value)
			return
	
	
	var y = 1-(obj.position.y / size.y)
	value.set_point_value(idx, y)
	var x = obj.position.x / size.x
	value.set_point_offset(idx, x)
	owner.on_value_changed(value)
	pass

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if add:
				if current_value != null:
					add = false
					mouse_filter = Control.MOUSE_FILTER_STOP
					var value = owner.B_object.get(owner.variable_name) as Curve
					var y = 1-(event.position.y / size.y)
					var x = event.position.x / size.x
					value.add_point(Vector2(x,y))
					owner.on_value_changed(value)
				pass
			pass
	pass

var add = false
var remove = false

func mode(mod):
	if mod == "add": add = true
	if mod == "remove": remove = true
	pass

func editstart():
	owner.editing = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func editstop():
	owner.editing = false
	mouse_filter = Control.MOUSE_FILTER_PASS

func set_tangent_l(idx, value):
	if current_value is Curve:
		current_value.set_point_left_tangent(idx,value)
		owner.on_value_changed(current_value)
		pass
	pass
func set_tangent_r(idx, value):
	if current_value is Curve:
		current_value.set_point_right_tangent(idx,value)
		owner.on_value_changed(current_value)
		pass
	pass

func _on_resized():
	update(current_value)
	pass
