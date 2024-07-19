extends Node2D

var current_node : BlokiNode = null
func select_node(node : BlokiNode):
	current_node = node
	
	pass

enum axis{
	none,
	nx,
	px,
	ny,
	py,
	nxy,
	pxy,
	nxpy,
	pxny,
}

var axis_selected = axis.none

func _process(_delta: float) -> void:
	if current_node == null or not is_instance_valid(current_node) or current_node is not BlokiNode:
		$"-x".visible = false
		$"+x".visible = false
		$"-y".visible = false
		$"+y".visible = false
		$"-xy".visible = false
		$"+xy".visible = false
		$"-x+y".visible = false
		$"+x-y".visible = false
		return
	var rect : Rect2 = current_node.get_global_rect()
	var n_x = rect.position + Vector2(0, rect.size.y/2.0)
	var p_x = rect.position + Vector2(rect.size.x, rect.size.y/2.0)
	var n_y = rect.position + Vector2(rect.size.x/2.0, 0)
	var p_y = rect.position + Vector2(rect.size.x/2.0, rect.size.y)
	var n_xy = rect.position
	var p_xy = rect.position + Vector2(rect.size.x, rect.size.y)
	var nxpy = rect.position + Vector2(0, rect.size.y)
	var pxny = rect.position + Vector2(rect.size.x, 0)
	$"-x".visible = true
	$"+x".visible = true
	$"-y".visible = true
	$"+y".visible = true
	$"-xy".visible = true
	$"+xy".visible = true
	$"-x+y".visible = true
	$"+x-y".visible = true
	$"-x".position = n_x - (Vector2(20,20) / ApiNodes.TouchCamera2D.zoom) - Vector2(40,0) / ApiNodes.TouchCamera2D.zoom
	$"+x".position = p_x - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom + Vector2(40,0) / ApiNodes.TouchCamera2D.zoom
	$"-y".position = n_y - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom - Vector2(0,40) / ApiNodes.TouchCamera2D.zoom
	$"+y".position = p_y - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom + Vector2(0,40) / ApiNodes.TouchCamera2D.zoom
	$"-xy".position = n_xy - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom - Vector2(40,40) / ApiNodes.TouchCamera2D.zoom
	$"+xy".position = p_xy - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom + Vector2(40,40) / ApiNodes.TouchCamera2D.zoom
	$"-x+y".position = nxpy - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom + Vector2(-40,40) / ApiNodes.TouchCamera2D.zoom
	$"+x-y".position = pxny - Vector2(20,20) / ApiNodes.TouchCamera2D.zoom + Vector2(40,-40) / ApiNodes.TouchCamera2D.zoom
	for a in get_children():
		a.size = Vector2(40,40) / ApiNodes.TouchCamera2D.zoom
		load("res://Plugins/global_plugins/scale/controls/scale_controls.tres").border_width_bottom = clamp(5 / ApiNodes.TouchCamera2D.zoom.x, 5, 5 / ApiNodes.TouchCamera2D.zoom.x)
		load("res://Plugins/global_plugins/scale/controls/scale_controls.tres").border_width_top = clamp(5 / ApiNodes.TouchCamera2D.zoom.x, 5, 5 / ApiNodes.TouchCamera2D.zoom.x)
		load("res://Plugins/global_plugins/scale/controls/scale_controls.tres").border_width_left = clamp(5 / ApiNodes.TouchCamera2D.zoom.x, 5, 5 / ApiNodes.TouchCamera2D.zoom.x)
		load("res://Plugins/global_plugins/scale/controls/scale_controls.tres").border_width_right = clamp(5 / ApiNodes.TouchCamera2D.zoom.x, 5, 5 / ApiNodes.TouchCamera2D.zoom.x)
	pass

var old_rect : Rect2
var start_pos : Vector2

func _input(event: InputEvent) -> void:
	if current_node == null or not is_instance_valid(current_node) or current_node is not BlokiNode:
		return
	if event is InputEventMouseMotion:
		if axis_selected == axis.nx or axis_selected == axis.nxy or axis_selected == axis.nxpy:
			var projected_pos = ApiNodes.TouchCamera2D.project_position(event.global_position)
			var start_projected_pos = ApiNodes.TouchCamera2D.project_position(start_pos)
			var plane = Plane(Vector3(-1,0,0), Vector3(start_projected_pos.x, start_projected_pos.y, 0))
			var dst = plane.distance_to(Vector3(projected_pos.x, projected_pos.y, 0))
			var new_rect = old_rect.grow_individual(dst,0,0,0)
			new_rect.position.y = current_node.get_global_rect().position.y
			new_rect.size.y = current_node.get_global_rect().size.y
			current_node.global_position = new_rect.position
			current_node.size = new_rect.size
		if axis_selected == axis.px or axis_selected == axis.pxy or axis_selected == axis.pxny:
			var projected_pos = ApiNodes.TouchCamera2D.project_position(event.global_position)
			var start_projected_pos = ApiNodes.TouchCamera2D.project_position(start_pos)
			var plane = Plane(Vector3(1,0,0), Vector3(start_projected_pos.x, start_projected_pos.y, 0))
			var dst = plane.distance_to(Vector3(projected_pos.x, projected_pos.y, 0))
			var new_rect = old_rect.grow_individual(0,0,dst,0)
			new_rect.position.y = current_node.get_global_rect().position.y
			new_rect.size.y = current_node.get_global_rect().size.y
			current_node.global_position = new_rect.position
			current_node.size = new_rect.size
		if axis_selected == axis.ny or axis_selected == axis.nxy or axis_selected == axis.pxny:
			var projected_pos = ApiNodes.TouchCamera2D.project_position(event.global_position)
			var start_projected_pos = ApiNodes.TouchCamera2D.project_position(start_pos)
			var plane = Plane(Vector3(0,-1,0), Vector3(start_projected_pos.x, start_projected_pos.y, 0))
			var dst = plane.distance_to(Vector3(projected_pos.x, projected_pos.y, 0))
			var new_rect = old_rect.grow_individual(0,dst,0,0)
			new_rect.position.x = current_node.get_global_rect().position.x
			new_rect.size.x = current_node.get_global_rect().size.x
			current_node.global_position = new_rect.position
			current_node.size = new_rect.size
		if axis_selected == axis.py or axis_selected == axis.pxy or axis_selected == axis.nxpy:
			var projected_pos = ApiNodes.TouchCamera2D.project_position(event.global_position)
			var start_projected_pos = ApiNodes.TouchCamera2D.project_position(start_pos)
			var plane = Plane(Vector3(0,1,0), Vector3(start_projected_pos.x, start_projected_pos.y, 0))
			var dst = plane.distance_to(Vector3(projected_pos.x, projected_pos.y, 0))
			var new_rect = old_rect.grow_individual(0,0,0,dst)
			new_rect.position.x = current_node.get_global_rect().position.x
			new_rect.size.x = current_node.get_global_rect().size.x
			current_node.global_position = new_rect.position
			current_node.size = new_rect.size
	pass


func _on_nx_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.nx
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass

func _on_px_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.px
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass

func _on_ny_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.ny
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass

func _on_py_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.py
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass


func _on_nxy_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.nxy
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass


func _on_pxy_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.pxy
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass


func _on_nxpy_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.nxpy
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass


func _on_pxny_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			axis_selected = axis.pxny
			old_rect = current_node.get_global_rect()
			start_pos = event.global_position
		if not event.pressed:
			axis_selected = axis.none
			commit()
	pass


func commit():
	if not is_instance_valid(current_node): return
	if current_node is not BlokiNode: return
	var start = old_rect
	var current = current_node.get_global_rect()
	var undo = ApiNodes.CURRENT_UNDO_REDO
	undo.create_action("resize")
	undo.add_do_property(current_node, "global_position", current.position)
	undo.add_do_property(current_node, "size", current.size)
	undo.add_undo_property(current_node, "global_position", start.position)
	undo.add_undo_property(current_node, "size", start.size)
	undo.commit_action()
	
	
	var parent = null
	#current_node.get_parent() as BlokiNode
	if parent != null:
		var p_size = parent.size
		
		
		var p = current_node.position
		var p_s = current_node.position + current_node.size
		
		var anc_left = p.x/p_size.x
		var anc_right = p_s.x/p_size.x
		var anc_top = p.y/p_size.y
		var anc_bottom = p_s.y/p_size.y
		
		print(anc_left)
		print(anc_right)
		print(anc_top)
		print(anc_bottom)
		
		current_node.set_anchor(SIDE_LEFT, anc_left)
		current_node.set_anchor(SIDE_RIGHT, anc_right)
		current_node.set_anchor(SIDE_BOTTOM, anc_bottom)
		current_node.set_anchor(SIDE_TOP, anc_top)
		pass
	
	pass
