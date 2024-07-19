extends BlokiPlugin

var moved = false
var start_pos : Vector2
var current_pos : Vector2
var index : int

func _init() -> void:
	name = "move"

var can_edit = false
var node_startpos
var node_currentpos
var diff_pos
func on_spawn():
	Api.forward_input.connect(func(event):
		if not is_enabled(): return
		if event is InputEventScreenDrag:
			current_pos = event.position
			if not moved:
				moved = (current_pos - start_pos).length() >= 2
			if moved and can_edit:
				ApiNodes.SELECTED_NODE.global_position = ApiNodes.TouchCamera2D.project_position(event.position) - diff_pos
				current_pos = ApiNodes.SELECTED_NODE.global_position
		if event is InputEventScreenTouch:
			if event.is_pressed():
				if ApiNodes.SELECTED_NODE == null: return
				moved = false
				var p_pos = ApiNodes.TouchCamera2D.project_position(event.position)
				var rect = ApiNodes.SELECTED_NODE.get_global_rect()
				can_edit = rect.has_point(p_pos) and ApiNodes.SELECTED_NODE is BlokiNode
				if can_edit:
					ApiMem.camera_movement_enabled = false
					node_startpos = ApiNodes.SELECTED_NODE.global_position
					diff_pos = ApiNodes.TouchCamera2D.project_position(event.position) - node_startpos
				index = event.index
				start_pos = event.position
			if event.is_released():
				if event.index != index: return
				if moved and can_edit:
					var undo = ApiNodes.CURRENT_UNDO_REDO
					undo.create_action("move")
					undo.add_do_property(ApiNodes.SELECTED_NODE, "global_position", current_pos)
					undo.add_undo_property(ApiNodes.SELECTED_NODE, "global_position", node_startpos)
					undo.commit_action()
				if can_edit:
					ApiMem.camera_movement_enabled = true
				moved = false
				can_edit = false
				index = -1
				diff_pos = null
			pass
		)
