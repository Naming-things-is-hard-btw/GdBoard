class_name RightClick extends Node2D

signal right_click_start(rc_position)
signal right_click_drag(rc_start_position, rc_drag_position)
signal right_click_end(rc_position, did_drag)
signal right_click_cancel(rc_position)

@export var can_drag = false
@export var drag_visible = true

var _timer : Timer

func Cancel():
	if _right_click:
		_r_click_end()
		right_click_cancel.emit(_end_point)
	_possible_right_click = false
	_right_click = false
	_right_click_drag = false
	_timer.stop()
	queue_redraw()
	pass

func Stop():
	_possible_right_click = false
	_right_click = false
	_right_click_drag = false
	_timer.stop()
	right_click_end.emit(_end_point, _right_click_drag)
	queue_redraw()
	pass

func _init() -> void:
	_timer = Timer.new()
	add_child(_timer, true, Node.INTERNAL_MODE_FRONT)
	_timer.timeout.connect(timeout)
	_timer.autostart = false
	_timer.one_shot = true
	pass

func timeout():
	_right_click = true
	right_click_start.emit(_end_point)
	_r_click_start()
	pass

var tween : Tween
func _r_click_start():
	if tween: tween.kill()
	tween = create_tween()
	_right_click_rect.position = _end_point
	var rect = Rect2(_end_point - Vector2(30,30), Vector2(60,60))
	tween.tween_property(self, "_right_click_rect", rect, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	pass

func _r_click_end():
	if tween: tween.kill()
	tween = create_tween()
	_right_click_rect.position = _end_point - Vector2(30,30)
	var rect = Rect2(_end_point, Vector2())
	tween.tween_property(self, "_right_click_rect", rect, 0.2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	pass

var _start_point : Vector2
var _end_point : Vector2
var _possible_right_click = false
var _right_click = false
var _right_click_drag = false


func UpdateInput(event : InputEvent):
	if event is InputEventScreenTouch:
		if event.index != 0: Cancel()
		if event.index == 0:
			if event.pressed:
				_start_point = event.position
				_end_point = event.position
				_possible_right_click = true
				_timer.start(0.4)
			if not event.pressed:
				if not _right_click: Cancel()
				else:
					Stop()
					_r_click_end()
	if event is InputEventScreenDrag:
		_end_point = event.position
		if _end_point.distance_to(_start_point) >= 3:
			if not _right_click: Cancel()
			else: start_drag()
			if _right_click_drag:
				queue_redraw()
				right_click_drag.emit(_start_point, _end_point)
	pass

func start_drag():
	if not can_drag:
		Cancel()
		return
	if not _right_click_drag:
		_r_click_end()
	_right_click_drag = true
	pass

var _right_click_rect : Rect2:
	set(new):
		_right_click_rect = new
		queue_redraw()


func _draw() -> void:
	draw_rect(_right_click_rect , Color(0.0, 0.4 , 0.8, 0.3), true)
	draw_rect(_right_click_rect , Color(0.0, 0.8 , 1, 1), false)
	if not drag_visible: return
	if _right_click_drag:
		var rect = Rect2(_start_point, _end_point - _start_point)
		draw_rect(rect , Color(0.0, 0.4 , 0.8, 0.3), true)
		draw_rect(rect , Color(0.0, 0.8 , 1, 1), false)
	pass
