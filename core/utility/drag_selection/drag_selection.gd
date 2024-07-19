extends Node2D
class_name DragSelection

var _start_global_point : Vector2
var drag = false
var _start : Vector2
var _size : Vector2

func set_start_position(pos):
	_start_global_point = pos
	drag = true

func set_end_position(pos):
	_start = _start_global_point.min(pos)
	var _end = _start_global_point.max(pos)
	_size = _end - _start
	queue_redraw()

func reset():
	drag = false
	queue_redraw()

func _draw() -> void:
	if drag:
		var rect = Rect2(_start, _size)
		draw_rect(rect , Color(0.0, 0.4 , 0.8, 0.3), true)
		draw_rect(rect , Color(0.0, 0.8 , 1, 1), false)
	pass
