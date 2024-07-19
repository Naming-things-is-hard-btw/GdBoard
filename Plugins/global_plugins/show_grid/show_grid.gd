extends BlokiPlugin

var button
func on_enable():
	button = get_ui_tool_panel(UI_TOOL_MODE.RIGHT).add_button(preload("res://theme/modern_icons/grid.svg"))
	button.pressed.connect(_dup)
	pass

func on_disable():
	if is_instance_valid(button):
		button.queue_free()
	pass

func _init() -> void:
	name = "show_grid"

func _dup():
	ApiMem.show_grid = not ApiMem.show_grid
	pass
