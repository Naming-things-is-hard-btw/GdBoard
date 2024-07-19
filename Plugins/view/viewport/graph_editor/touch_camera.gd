class_name TouchCamera
extends Camera2D

var first_finger
var second_finger
var mouse_move = false
var mouse_rotate = false
var resize = false

var can_move = true

func _init() -> void:
	ApiNodes.TouchCamera2D = self
	pass

@export var cam_zoom = Vector2(0.7,0.7)

func select_node(pos : Vector2) -> Node:
	return _select_node(project_position(pos), ApiNodes.CURRENT_TREE_ROOT)

func _select_node(click_position : Vector2, root : Node) -> Node:
	var children = root.get_children()
	for i in range(children.size()-1, -1, -1):
		var child : BlokiNode = children[i]
		if child == null: continue
		if not child.folded:
			var n = _select_node(click_position, child)
			if not child.clip_contents:
				if n != null and n.visible:
					return n
			if child.clip_contents:
				if n != null and n.visible and child.get_global_rect().has_point(click_position):
					return n
		if child is BlokiNode:
			var rect : Rect2 = child.get_global_rect()
			if rect.has_point(click_position) and child.visible:
				return child
	return null


func project_position(pos : Vector2) -> Vector2:
	var camera_scale = (1.0/zoom.x)
	var viewport_half_size = (get_viewport_rect().size/2.0) * camera_scale
	var camera_global_position = global_position
	var _pos = pos * camera_scale
	return camera_global_position - viewport_half_size + _pos

func _unhandled_input(event):
	if not can_move: return
	if not ApiMem.camera_movement_enabled: return
	if event is InputEventScreenTouch:
		if event.pressed: touchscreen_pressed(event)
		if not event.pressed: touchscreen_released(event)
	if event is InputEventScreenDrag:
		if event.index == 0:
			move(event.relative)
			first_finger = event.position
			if resize:
				zoom_in_out( calc_relative_distance(first_finger, second_finger) / 300 )
		if event.index == 1:
			move(event.relative)
			second_finger = event.position
			if resize:
				zoom_in_out( calc_relative_distance(first_finger, second_finger) / 300 )
		pass
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP: zoom_in_out(0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN: zoom_in_out(-0.1)
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.is_pressed():
				start_moving()
				mouse_move = true
			if event.is_released():
				stop_moving()
				mouse_move = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed(): mouse_rotate = true
			if event.is_released(): mouse_rotate = false
	if event is InputEventMouseMotion and mouse_move:
		move(event.relative)

func touchscreen_pressed(event):
	if event.index == 0:
		start_moving()
		first_finger = event.position
	if event.index == 1:
		resize = true
		second_finger = event.position
		reset_relative_distanse(first_finger, second_finger)

func touchscreen_released(event):
	if event.index == 0:
		stop_moving()
	if event.index == 1:
		resize = false

var old_distance
var distanse
func calc_relative_distance(_first_finger, _second_finger):
	var relative_vector_ab : Vector2 = _first_finger - _second_finger
	distanse = sqrt((relative_vector_ab.x * relative_vector_ab.x ) + (relative_vector_ab.y * relative_vector_ab.y))
	var relative_distanse = distanse - old_distance
	old_distance = distanse
	return relative_distanse

func reset_relative_distanse(_first_finger, _second_finger):
	var relative_vector_ab = _first_finger - _second_finger
	distanse = sqrt((relative_vector_ab.x * relative_vector_ab.x ) + (relative_vector_ab.y * relative_vector_ab.y))
	old_distance = distanse

signal on_zoom()
func zoom_in_out(amount):
	cam_zoom += Vector2(amount / (1 / cam_zoom.x), amount / (1/cam_zoom.y))
	cam_zoom.x = clamp(cam_zoom.x, 0.01, 100)
	cam_zoom.y = clamp(cam_zoom.y, 0.01, 100)
	on_zoom.emit()
	pass

func _process(delta):
	zoom.x = lerp(zoom.x, cam_zoom.x, 11 * delta)
	zoom.y = lerp(zoom.y, cam_zoom.y, 11 * delta)

func start_moving():
	is_moving = true

func stop_moving():
	is_moving = false

var is_moving = false
func move(relative_position):
	if not is_moving: return
	var pos : Vector2 = relative_position * 1.0 / zoom
	position -= pos.rotated(rotation)
	pass
