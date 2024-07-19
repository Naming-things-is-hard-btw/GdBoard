extends BlokiPlugin

var button
func on_enable():
	button = get_ui_tool_panel(UI_TOOL_MODE.LEFT).add_button(preload("res://theme/modern_icons/content_duplicate.svg"))
	button.pressed.connect(_dup)
	button.visible = false
	pass

func _init() -> void:
	name = "duplicate"

func on_disable():
	if is_instance_valid(button):
		button.queue_free()
	pass

func on_spawn():
	ApiNodes.Plugins.on_selecting.connect(func(a):
		await get_tree().process_frame
		if is_instance_valid(button):
			button.visible = (is_instance_valid(button) and ApiNodes.SELECTED_NODE is BlokiNode)
		)
	Api.node_selected.connect(func(node):
		if not is_instance_valid(button): return
		button.visible = (is_instance_valid(button) and node is BlokiNode)
		)
	pass

func _dup():
	var object = ApiNodes.SELECTED_NODE
	if object == null: return
	if object is BlokiNode:
		var aaa = object._duplicate()
		object.get_parent().add_child(aaa, true)
		Api.update_world.emit()
		Api.select_node(aaa)
	pass
