extends PanelContainer
class_name BetterSpinbox
@export var value : float = 0
#var _value : float = 0
@export var step : float = 10
@export var expoEdit : bool = false
@export var rounded = false
signal on_value_changed(_val)

var internal_drag_balue = 0

var dragged = false
func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			dragged = false
			internal_drag_balue = value
			pass
		if not event.pressed:
			if not dragged:
				$LineEdit.show()
				$LineEdit.select_all()
				$Label.hide()
				$LineEdit.text = str(value)
				pass
			pass
		pass
	if event is InputEventScreenDrag:
		#just to change y to increase going up not down
		event.relative.y *= -1
		if expoEdit:
			if value > -1 and value < 1:
				value += (event.relative.x / get_viewport_rect().size.x) * step
				value += (event.relative.y / get_viewport_rect().size.y) * step
			else: if value < 0:
				value -= value * (event.relative.x / get_viewport_rect().size.x) * step
				value -= value * (event.relative.y / get_viewport_rect().size.y) * step
			else:
				value += value * (event.relative.x / get_viewport_rect().size.x) * step
				value += value * (event.relative.y / get_viewport_rect().size.y) * step
		else:
			internal_drag_balue += (event.relative.x / get_viewport_rect().size.x) * step
			internal_drag_balue += (event.relative.y / get_viewport_rect().size.y) * step
		#if rounded: value = round(value)
		#else: value = value
		value = internal_drag_balue
		on_value_changed.emit(value)
		$Label.text = str(snappedf(value,0.01))
		dragged = true
		pass
	pass


func _on_LineEdit_text_entered(new_text : String):
	value = float(new_text)
	$LineEdit.hide()
	$Label.show()
	$LineEdit.text = ""
	$Label.text = str(snappedf(value,0.01))
	on_value_changed.emit(value)
	pass


func _on_Timer_timeout():
	$Label.text = str(snappedf(value,0.01))
	
