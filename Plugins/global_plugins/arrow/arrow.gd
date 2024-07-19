extends BlokiPlugin

var instance : BlokiArrow = null
var head : BlokiArrow = null
var can_add = false

func _init() -> void:
	name = "arrow"
func on_spawn():
	Api.forward_input.connect(func(event):
		if not is_enabled(): return
		if not can_add: return
		if event is InputEventScreenDrag:
			if instance != null and head != null:
				head.position = ApiNodes.TouchCamera2D.project_position(event.position) - instance.global_position
		if event is InputEventScreenTouch:
			if event.is_pressed():
				var pos = ApiNodes.TouchCamera2D.project_position(event.position)
				instance = BlokiArrow.new()
				instance.global_position = pos - instance.size/2.0
				head = BlokiArrow.new()
				instance.add_child(head, true)
				instance.name = "arrow"
				head.name = "head"
				ApiNodes.CURRENT_TREE_ROOT.add_child(instance, true)
				ApiMem.camera_movement_enabled = false
			if event.is_released() and instance != null:
				ApiMem.camera_movement_enabled = true
				button.button_pressed = false
				can_add = false
				Api.update_world.emit()
				Api.select_node(instance)
				instance = null
				head = null
		)

var button : Button
func on_enable():
	button = get_ui_tool_panel(UI_TOOL_MODE.DOWN).add_button(preload("res://theme/modern_icons/edit.svg"))
	button.toggle_mode = true
	button.button_pressed = can_add
	button.pressed.connect(func():
		can_add = button.button_pressed
		)
	pass
