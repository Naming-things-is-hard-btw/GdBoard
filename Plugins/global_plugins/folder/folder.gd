extends BlokiPlugin

var button
func on_enable():
	button = get_ui_tool_panel(UI_TOOL_MODE.LEFT).add_button(preload("res://theme/icons/utility.png"))
	button.pressed.connect(_act)
	button.visible = false
	pass

func _init() -> void:
	name = "folder"

func on_disable():
	if is_instance_valid(button):
		button.queue_free()
	pass

func on_spawn():
	ApiNodes.Plugins.on_selecting.connect(func(a):
		await get_tree().process_frame
		if is_instance_valid(button):
			button.visible = (is_instance_valid(button) and ApiNodes.SELECTED_NODE is BlokiTransform)
		)
	Api.node_selected.connect(func(node):
		if not is_instance_valid(button): return
		button.visible = (is_instance_valid(button) and node is BlokiTransform)
		)
	pass

func _act():
	var object : Node = ApiNodes.SELECTED_NODE
	if object == null: return
	if object is BlokiTransform:
		var newnode = BlokiNode.new()
		newnode.name = newnode._get_info()["name"]
		newnode.global_position = object.global_position
		newnode.size = object.size
		ApiNodes.CURRENT_TREE_ROOT.add_child(newnode, true)
		for a in object.get_children():
			a.reparent(newnode, true)
		object.queue_free()
		await get_tree().process_frame
		Api.select_node(newnode)
		Api.update_world.emit()
	pass
