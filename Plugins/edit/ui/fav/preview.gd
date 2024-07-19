extends PanelContainer

var data : ItemGroup
var text : String:
	set(new):
		$Control/Label.text = new
var icon : Texture2D:
	set(new):
		$Control/TextureRect.texture = new


var startpos : Vector2
var op_not_determined = false
var custom_event : InputEventMouseButton
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and op_not_determined:
		if abs(startpos.x - event.position.x) > 20:
			op_not_determined = false
			custom_event.pressed = false
			Input.parse_input_event(custom_event)
			await get_tree().process_frame
			_down()
		if abs(startpos.y - event.position.y) > 20:
			op_not_determined = false
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				startpos = event.position
				op_not_determined = true
				custom_event = event.duplicate()
			if not event.pressed:
				op_not_determined = false
	pass

func unfold(root : BlokiNode):
	for a in root.get_children():
		if a is BlokiNode:
			a.folded = false
			unfold(a)
	pass

var instance : Node
func _down():
	if data == null: return
	if not is_instance_valid(data): return
	if data is not ItemGroup: return
	
	#instancing
	instance = data.scene.instantiate()
	instance.name = data.item_name
	if instance is BlokiNode:
		instance = instance._duplicate()
		instance.folded = false
		unfold(instance)
	
	ApiNodes.CURRENT_TREE_ROOT.add_child(instance,true)
	#parenting
	var _name = instance.name
	#if ApiNodes.SELECTED_NODE is BlokiNode:
	#	instance.reparent(ApiNodes.SELECTED_NODE)
	#else: 
	instance.reparent(ApiNodes.CURRENT_TREE_ROOT)
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
