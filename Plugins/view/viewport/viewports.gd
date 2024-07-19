extends Control

func _input(event: InputEvent) -> void:
	$RightClick.UpdateInput(event)
	Api.forward_input.emit(event)
	pass

func _on_right_click_right_click_start(rc_position: Variant) -> void:
	Api.virtual_mouse_right_click.emit(rc_position, Api.mouse_input_state.pressed)

func _on_right_click_right_click_cancel(rc_position: Variant) -> void:
	Api.virtual_mouse_right_click.emit(rc_position, Api.mouse_input_state.canceled)

func _on_right_click_right_click_drag(rc_start_position: Variant, rc_drag_position: Variant) -> void:
	Api.virtual_mouse_right_click.emit(rc_drag_position, Api.mouse_input_state.draging)

func _on_right_click_right_click_end(rc_position: Variant, did_drag: Variant) -> void:
	Api.virtual_mouse_right_click.emit(rc_position, Api.mouse_input_state.done)
