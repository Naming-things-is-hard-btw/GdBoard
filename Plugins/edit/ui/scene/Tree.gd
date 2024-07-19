extends Tree

var root : TreeItem
func _ready():
	Api.update_world.connect(func():
		_refresh())
	Api.node_selected.connect(_OBJECT_selected)
	Projects.open_proj.connect(_refresh)
	pass

func _OBJECT_selected(node):
	if root == null: _refresh()
	deselect_all()
	if is_instance_valid(node): _set_selected(node, root)
	pass

func _set_selected(node, treeitem : TreeItem):
	if not is_instance_valid(node): return
	for a in treeitem.get_children():
		if a.get_metadata(0) == node:
			if not a.is_selected(0):
				a.select(0)
			scroll_to_item(a)
		else : a.deselect(0)
		_set_selected(node, a)
	pass

func _refresh():
	clear()
	root = create_item()
	root.set_icon(0, preload("res://theme/icons/tabs.png"))
	var _name
	if Projects.current_project:
		_name = Projects.current_project.project_name
	if not _name: _name = "root"
	root.set_text(0, _name)
	if not is_instance_valid(ApiNodes.CURRENT_TREE_ROOT): return
	_load_tree(ApiNodes.CURRENT_TREE_ROOT, root)
	queue_redraw()
	pass

func _load_tree(_root : Node, item_root : TreeItem):
	#set_column_expand(1,false)
	for child in _root.get_children():
		if not child is BlokiNode: continue
		var item = create_item(item_root)
		item.set_metadata(0, child)
		item.set_collapsed_recursive(child.folded)
		item.set_icon(0, (child as BlokiNode)._get_info()["icon"])
		item.set_text(0, child.name)
		_load_tree(child, item)
	pass

func _on_Tree_nothing_selected():
	Api.select_node(null)
	pass

func _on_cell_selected() -> void:
	if get_selected_column() == 0:
		if ApiNodes.SELECTED_NODE == get_selected().get_metadata(0): return
		if ApiNodes.SELECTED_NODE is BlokiTransform: return
		Api.select_node(get_selected().get_metadata(0))
	pass

#renaming nodes
func _on_item_edited() -> void:
	if get_selected_column() == 0:
		var item = get_selected()
		if item == root: return
		var node = item.get_metadata(0)
		var newname = item.get_text(0)
		var oldname = node.name
		
		ApiNodes.CURRENT_UNDO_REDO.create_action("rename")
		ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
			node.name = newname
			Api.update_world.emit()
			)
		ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
			node.name = oldname
			Api.update_world.emit()
			)
		ApiNodes.CURRENT_UNDO_REDO.commit_action()
	pass


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is BlokiNode:
		drop_mode_flags = DROP_MODE_INBETWEEN + DROP_MODE_ON_ITEM
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data is BlokiNode:
		var item = get_item_at_position(at_position)
		var old_parent = data.get_parent()
		if item:
			var rect = get_item_area_rect(item)
			var p1 = rect.position
			var p2 = rect.position + rect.size
			var dst1 = abs(p1.y - at_position.y)
			var dst2 = abs(p2.y - at_position.y)
			var move_above = (dst1 < (rect.size.y/3.0))
			var move_below = (dst2 < (rect.size.y/3.0))
			if move_above or move_below:
				if data.is_ancestor_of(item.get_metadata(0).get_parent()) or data.is_ancestor_of(item.get_metadata(0)):
					printerr("invalid reparenting")
					return
				data.reparent(item.get_metadata(0).get_parent())
				var idx = item.get_index()
				data.get_parent().move_child(data, idx)
				Api.update_world.emit()
				return
		
		## IF NODE IS NOT REPARENTING TO ITSELF VVV
		if item and data != item.get_metadata(0):
			var newparent = item.get_metadata(0)
			if item == root:
				newparent = ApiNodes.CURRENT_TREE_ROOT
			if data.is_ancestor_of(newparent):
				printerr("invalid reparenting")
				return
			ApiNodes.CURRENT_UNDO_REDO.create_action("reparent")
			ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
				data.reparent(newparent)
				Api.update_world.emit()
				)
			ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
				data.reparent(old_parent)
				Api.update_world.emit()
				)
			ApiNodes.CURRENT_UNDO_REDO.commit_action()
		else:
			ApiNodes.CURRENT_UNDO_REDO.create_action("reparent")
			ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
				data.reparent(ApiNodes.CURRENT_TREE_ROOT)
				Api.update_world.emit()
				)
			ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
				data.reparent(old_parent)
				Api.update_world.emit()
				)
			ApiNodes.CURRENT_UNDO_REDO.commit_action()
	pass

var startpos
var possible_drag = false
var _item
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				possible_drag = false
			pass

func _gui_input(event: InputEvent) -> void:
	$RightClick.UpdateInput(event)
	if event is InputEventMouseMotion:
		if not startpos: return
		var can_drag = event.position.distance_to(startpos) > 10
		if possible_drag and can_drag:
			startdrag()
			possible_drag = false
			startpos = null
			_item = null
	pass

func un_press(pos):
	var event = InputEventMouseButton.new()
	event.position = global_position + pos
	event.global_position = global_position + pos
	event.pressed = true
	event.button_index = MOUSE_BUTTON_LEFT
	get_viewport().push_input(event)
	event = InputEventMouseButton.new()
	event.position = global_position + pos
	event.global_position = global_position + pos
	event.pressed = false
	event.button_index = MOUSE_BUTTON_LEFT
	get_viewport().push_input(event)
	pass
func startdrag():
	if not is_instance_valid(_item):
		_item = get_item_at_position(startpos)
	if not is_instance_valid(_item): return
	var obj = _item.get_metadata(0)
	if not obj: return
	var inst = preload("res://core/components/ui_components/drag/drag.tscn").instantiate()
	inst.text = obj.name
	inst.icon = obj._get_info()["icon"]
	force_drag(obj, inst)

func _on_right_click_right_click_start(rc_position: Variant) -> void:
	startpos = rc_position
	possible_drag = true
	_item = get_item_at_position(rc_position)
	un_press(rc_position)
	pass

func _on_right_click_right_click_end(rc_position: Variant, did_drag: Variant) -> void:
	possible_drag = false
	if not did_drag:
		set_selected(get_item_at_position(rc_position),0)
		if get_selected() != root:
			edit_selected(true)
	pass


func _on_item_collapsed(item: TreeItem) -> void:
	if is_instance_valid(item.get_metadata(0)):
		if item.get_metadata(0) is BlokiNode:
			item.get_metadata(0).folded = item.collapsed
