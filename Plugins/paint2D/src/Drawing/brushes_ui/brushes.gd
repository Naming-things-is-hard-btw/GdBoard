extends Control

@export var brushes_ui : Control

func _show():
	visible = true
	brushes_ui.Update()
	pass

func _hide():
	visible = false
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_hide()

func _ready() -> void:
	_hide()
	$brushes/BoxContainer/ScrollContainer/BoxContainer/ColorPicker.color = get_tree().get_nodes_in_group("Paint2d_Global")[0].brush_color


func _on_scroll_container_done() -> void:
	_hide()
	pass


func _on_color_picker_color_changed(color: Color) -> void:
	get_tree().get_nodes_in_group("Paint2d_Global")[0].brush_color = color
	pass
