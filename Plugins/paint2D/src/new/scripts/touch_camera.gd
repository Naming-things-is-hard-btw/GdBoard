class_name TouchCameraa
extends Camera2D

var first_finger
var second_finger
var mouse_move = false
var mouse_rotate = false
var resize = false

@export var cam_zoom = Vector2(0.7,0.7)
@export var can_move = true

func _ready():
	ignore_rotation = false
	pass

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed: touchscreen_pressed(event)
		if not event.pressed: touchscreen_released(event)
	if event is InputEventScreenDrag:
		if event.index == 0:
			move(event.relative)
			first_finger = event.position
			if resize:
				zoom_in_out( calc_relative_distance(first_finger, second_finger) / 300 )
				_rotate( calc_relative_rotation(first_finger, second_finger) )
		if event.index == 1:
			move(event.relative)
			second_finger = event.position
			if resize:
				zoom_in_out( calc_relative_distance(first_finger, second_finger) / 300 )
				_rotate( calc_relative_rotation(first_finger, second_finger) )
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
	if event is InputEventMouseMotion and mouse_rotate:
		_rotate(event.relative.x/200)

func touchscreen_pressed(event):
	if event.index == 0:
		start_moving()
		first_finger = event.position
	if event.index == 1:
		resize = true
		second_finger = event.position
		reset_relative_distanse(first_finger, second_finger)
		reset_relative_rotation(first_finger, second_finger)

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

var start_rotation = 0.0
var current_rotation = 0.0
var old_relative_rotation = 0.0
func calc_relative_rotation(_first_finger, _second_finger):
	var relative_vector_ab : Vector2 = _first_finger - _second_finger
	current_rotation = relative_vector_ab.angle()
	var relative_rotation = current_rotation - start_rotation
	
	var result = relative_rotation - old_relative_rotation
	old_relative_rotation = relative_rotation
	return result

func reset_relative_rotation(_first_finger, _second_finger):
	var relative_vector_ab : Vector2 = _first_finger - _second_finger
	start_rotation = relative_vector_ab.angle()
	current_rotation = relative_vector_ab.angle()
	old_relative_rotation = 0.0
	pass

func _rotate(amount):
	rotation -= amount
	pass

func zoom_in_out(amount):
	cam_zoom += Vector2(amount / (1 / cam_zoom.x), amount / (1/cam_zoom.y))
	cam_zoom.x = clamp(cam_zoom.x, 0.01, 100)
	cam_zoom.y = clamp(cam_zoom.y, 0.01, 100)
	pass

func _process(delta):
	zoom.x = lerp(zoom.x, cam_zoom.x, 10 * delta)
	zoom.y = lerp(zoom.y, cam_zoom.y, 10 * delta)

func start_moving():
	is_moving = true

func stop_moving():
	is_moving = false

var is_moving = false
func move(relative_position):
	if not is_moving: return
	if not can_move: return
	var pos : Vector2 = relative_position * 1.0 / zoom
	position -= pos.rotated(rotation)
	pass
