extends Button

@export var noderoot : Node2D
@export var spawner : Control

var instance : Node

func _down():
	#instancing
	if noderoot.get_child_count() == 0: return
	instance = noderoot.get_child(0)
	#parenting
	var _name = instance.name
	if ApiNodes.SELECTED_NODE is BlokiNode:
		instance.reparent(ApiNodes.SELECTED_NODE)
	else: instance.reparent(ApiNodes.CURRENT_TREE_ROOT)
	var parent : Node = instance.get_parent()
	parent.remove_child(instance)
	instance.name = _name
	
	instance.global_position = ApiNodes.TouchCamera2D.project_position(ApiNodes.UI_VIEWPORT_WINDOW.get_local_mouse_position())
	
	var e = instance
	var p = parent
	ApiNodes.CURRENT_UNDO_REDO.create_action("add_node")
	ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
		p.add_child(e, true)
		Api.update_world.emit()
		Api.select_node(e)
		)
	ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
		p.remove_child(e)
		Api.update_world.emit()
		Api.select_node(null)
		)
	ApiNodes.CURRENT_UNDO_REDO.commit_action()
	if instance is BlokiNode:
		instance._disable_coll()
	ApiMem.camera_movement_enabled = false
	owner.hide()
	pass

func _input(event):
	if instance != null:
		if event is InputEventScreenDrag:
			instance.global_position = ApiNodes.TouchCamera2D.project_position(ApiNodes.UI_VIEWPORT_WINDOW.get_local_mouse_position()) - (instance.size/2.0)
		if event is InputEventScreenTouch:
			#cleanup
			if event.is_released():
				if instance is BlokiNode:
					instance._enable_coll()
				instance = null
				ApiMem.camera_movement_enabled = true
				owner.hide()
