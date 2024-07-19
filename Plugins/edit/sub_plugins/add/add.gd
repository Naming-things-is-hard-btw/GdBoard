extends BlokiPlugin

var button : Button
func on_enable():
	button = get_ui_tool_panel(UI_TOOL_MODE.DOWN).add_button(preload("res://theme/modern_icons/add.svg"))
	button.pressed.connect(_dup)
	pass

func on_disable():
	if is_instance_valid(button):
		button.queue_free()
	pass

func _init() -> void:
	name = "add_node"

func _dup():
	ApiNodes.UI_ADD_PANEL.show()
	pass
