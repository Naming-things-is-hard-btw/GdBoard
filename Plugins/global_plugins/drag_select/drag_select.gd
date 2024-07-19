extends BlokiPlugin


var drag_select = DragSelection.new()
var canvaslayer = CanvasLayer.new()
func _init() -> void:
	name = "drag_select"
	ApiNodes.Plugins_vp.add_child(canvaslayer, true)
	canvaslayer.add_child(drag_select, true, Node.INTERNAL_MODE_FRONT)
	canvaslayer.layer = 10
	Api.node_selected.connect(func(node):
		if node == null or node != transform_node:
			if is_instance_valid(transform_node):
				var tr_node = transform_node
				tr_node.commit()
				transform_node = null
				tr_node.queue_free()
				Api.update_world.emit()
				Api.select_node(null)
		)

var startpos
var drag = false
var transform_node : BlokiTransform = null

func _ready() -> void:
	Api.virtual_mouse_right_click.connect(func(pos, state):
		if not is_enabled(): return
		match state:
			Api.mouse_input_state.pressed: #### PRESS
				ApiMem.camera_movement_enabled = false
				startpos = pos
				drag_select.set_start_position(pos)
				drag = true
			Api.mouse_input_state.draging: #### DRAG
				drag_select.set_end_position(pos)
			Api.mouse_input_state.done: #### DONE DRAGGING
				DragSelect(pos)
				ApiMem.camera_movement_enabled = true
				drag_select.reset()
				drag = false
			Api.mouse_input_state.canceled: #### CANCELED
				ApiMem.camera_movement_enabled = true
				drag_select.reset()
				drag = false
		)
	pass


func DragSelect(pos):
	if is_instance_valid(transform_node):
		transform_node.commit()
		transform_node.queue_free()
	transform_node = BlokiTransform.new()
	ApiNodes.CURRENT_TREE_ROOT.add_child(transform_node, true)
	recursiv_selection(drag_select._start, drag_select._size, ApiNodes.CURRENT_TREE_ROOT)
	Api.update_world.emit()
	Api.select_node(transform_node)
	
	if is_instance_valid(transform_node):
		if transform_node.get_child_count() <= 0:
			Api.update_world.emit()
			Api.select_node(null)
			await get_tree().process_frame
			Api.select_node(null)



func recursiv_selection(pos : Vector2, _size : Vector2, _node : Node):
	for a in _node.get_children():
		if a is BlokiTransform: continue
		if a is BlokiNode:
			var rect : Rect2 = Rect2(pos, _size)
			var camera_scale = (1.0/ApiNodes.TouchCamera2D.zoom.x)
			var viewport_half_size = (ApiNodes.TouchCamera2D.get_viewport_rect().size/2.0) * camera_scale
			var camera_global_position = ApiNodes.TouchCamera2D.global_position
			var cam_space_pos = rect.position * camera_scale
			var cam_space_size = rect.size * camera_scale
			rect.position = camera_global_position - viewport_half_size + cam_space_pos
			rect.size = cam_space_size
			if rect.encloses(a.get_global_rect()):
				transform_node.select_nodes(a)
	for a in _node.get_children():
		if a is BlokiTransform: continue
		recursiv_selection(pos, _size, a)
		pass


func on_enable():
	pass
