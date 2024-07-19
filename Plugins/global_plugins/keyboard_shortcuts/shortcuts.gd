extends BlokiPlugin

func _init() -> void:
	name = "undo_redo"

func _unhandled_key_input(event):
	if not is_enabled(): return
	if event is InputEventKey:
		if not event.pressed: return
		if event.keycode == KEY_Z:
			if event.ctrl_pressed:
				if event.shift_pressed:
					if ApiNodes.CURRENT_UNDO_REDO.has_redo():
						ApiNodes.CURRENT_UNDO_REDO.redo()
				else:
					if ApiNodes.CURRENT_UNDO_REDO.has_undo():
						ApiNodes.CURRENT_UNDO_REDO.undo()
		pass
	
	
	
	pass
