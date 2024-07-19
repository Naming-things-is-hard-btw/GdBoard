@tool
class_name BlokiNode extends Control

var is_selected = false
var is_sub_selected = false
@export var folded = false
var coll_enabled = true
var copy_list : Array[String] = []


func _copydata(to : BlokiNode, duplicate_data : bool):
	for a in get_property_list():
		if copy_list.find(a["name"]) != -1:
			var dat = get(a["name"])
			if dat is Resource and duplicate_data:
				dat = dat.duplicate(true)
			to.set(a["name"], dat)
	pass

func _init():
	mouse_filter = MOUSE_FILTER_IGNORE
	visibility_changed.connect(func():
		if is_visible_in_tree(): _enable_coll()
		else: _disable_coll())
	Api.edit_mode_change.connect(func():
		queue_redraw()
		)
	copy_list.append("folded")
	copy_list.append("clip_contents")
	copy_list.append("name")
	copy_list.append("visible")
	copy_list.append("anchor_bottom")
	copy_list.append("anchor_left")
	copy_list.append("anchor_right")
	copy_list.append("anchor_top")
	copy_list.append("grow_horizontal")
	copy_list.append("grow_vertical")
	copy_list.append("offset_bottom")
	copy_list.append("offset_left")
	copy_list.append("offset_right")
	copy_list.append("offset_top")
	pass

func _duplicate() -> BlokiNode:
	var n = BlokiNode.new()
	_copydata(n, true)
	for a in get_children():
		if a is BlokiNode:
			n.add_child( a._duplicate(), true )
	return n

func get_area() -> Rect2:
	var area = get_global_rect()
	for a in get_children():
		if a is BlokiNode:
			area = area.merge(a.get_area())
	return area

func _disable_coll(recursive = true):
	coll_enabled = false
	if not recursive: return
	for a in get_children():
		if a is BlokiNode:
			a._disable_coll()
func _enable_coll(recursive = true):
	coll_enabled = true
	if not recursive: return
	for a in get_children():
		if a is BlokiNode:
			a._enable_coll()

func un_select():
	is_selected = false
	is_sub_selected = false
	queue_redraw()
	for a in get_children():
		if a is BlokiNode:
			a.un_select()
	pass

func select(recursive = true):
	if not is_inside_tree(): return
	if is_selected: return
	is_selected = true
	queue_redraw()
	if not recursive: return
	for a in get_children():
		if a is BlokiNode:
			a.sub_select()
	pass

func sub_select():
	if is_sub_selected: return
	is_sub_selected = true
	queue_redraw()
	for a in get_children():
		if a is BlokiNode:
			a.sub_select()
	pass

func _get_config(m : menu):
	m.add_bool("Visible", preload("res://theme/icons/visibility_on.png"), "visible", self, true, func():)
	m.add_bool("Clip Content", preload("res://theme/icons/visibility_on.png"), "clip_contents", self, true, func():)
	m.add_vector2("Position", preload("res://theme/modern_icons/position.svg"), "position", self, Vector2(0,0), func():)
	m.add_vector2("Size", preload("res://theme/icons/scale.png"), "size", self, Vector2(100,100), func():)
	pass

func delete(is_sub_action : bool = false):
	Api.select_node(null)
	var parent = get_parent()
	var node = self
	var idx = get_index()
	if not is_sub_action: ApiNodes.CURRENT_UNDO_REDO.create_action("delete")
	ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
		parent.remove_child(node)
		Api.update_world.emit()
		)
	ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
		parent.add_child(node, true)
		parent.move_child(node, idx)
		Api.update_world.emit()
		)
	if not is_sub_action: ApiNodes.CURRENT_UNDO_REDO.commit_action()
	pass

func _get_info():
	return {"name": "Item", "icon": preload("res://theme/icons/drag_select.png")}

func _draw() -> void:
	if not ApiMem.edit_mode: return
	var rect = Rect2(Vector2(2,2), size - Vector2(4,4))
	if is_selected:
		draw_rect(rect , Color(0.91, 0.741, 0, 0.1), true)
		draw_rect(rect , Color(0.911, 0.741, 0), false, 4)
	else:
		draw_rect(rect , Color(1, 1 , 1, 0.05), true)
		draw_rect(rect , Color(1, 1 , 1, 0.4), false, 2)
	pass
