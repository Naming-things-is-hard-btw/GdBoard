@tool
class_name BlokiTransform extends BlokiNode

func _get_info():
	return {"name": "تحريك", "icon":  preload("res://theme/icons/container.png")}

func _init():
	super._init()
	size = Vector2()
	name = "Transform"

func _duplicate() -> BlokiNode:
	var n = BlokiTransform.new()
	for a in get_children():
		if a is BlokiNode:
			n.add_child(a._duplicate(), true)
	n.global_position = global_position
	n.size = size
	ApiNodes.CURRENT_TREE_ROOT.add_child(n, true)
	for a in n.get_children():
		if a is BlokiNode:
			var oldname = a.name
			a.reparent(ApiNodes.CURRENT_TREE_ROOT)
			ApiNodes.CURRENT_TREE_ROOT.remove_child(a)
			a.name = oldname
			ApiNodes.CURRENT_TREE_ROOT.add_child(a,true)
	n.queue_free()
	return self


func delete(is_sub_action : bool = false):
	var nodes = get_children()
	ApiNodes.CURRENT_UNDO_REDO.create_action("multi_delete")
	for a in get_children():
		delete_children(a)
	ApiNodes.CURRENT_UNDO_REDO.commit_action()
	Api.select_node(null)
	Api.update_world.emit()
	queue_free()

func delete_children(_node):
	var node = _node
	ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
		node.reparent(ApiNodes.CURRENT_TREE_ROOT)
		node.get_parent().remove_child(node)
		Api.update_world.emit()
		)
	ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
		ApiNodes.CURRENT_TREE_ROOT.get_node_or_null(node.get_meta("old_path",".")).add_child(node, true)
		node.name = node.get_meta("old_name",".")
		node.un_select()
		Api.update_world.emit()
		)
	pass

func select_nodes(a : BlokiNode):
	if get_children().find(a) != -1: return
	
	if get_child_count() == 0:
		global_position = a.global_position
	
	a.set_meta("old_name", a.name)
	a.set_meta("old_path", ApiNodes.CURRENT_TREE_ROOT.get_path_to(a.get_parent()))
	a.set_meta("old_pos", a.position)
	a.set_meta("old_scal", a.size)
	a.reparent(self)
	
	var pos_arr = []
	for b in get_children():
		pos_arr.append(b.global_position)
	
	var rect = get_area()
	global_position = rect.position
	size = rect.size
	
	var child_array = get_children()
	for i in range(child_array.size()):
		var b = child_array[i]
		b.global_position = pos_arr[i]
	pass


var cleaning_up = false
func commit():
	if cleaning_up:
		printerr("already at commit transform")
		return
	if get_child_count() < 1: return
	fail_arr.clear()
	fix_loops = 0
	cleaning_up = true
	ApiNodes.CURRENT_UNDO_REDO.create_action("multi_transform")
	for a in get_children():
		_recursive_commit(a)
	fix_fail()
	ApiNodes.CURRENT_UNDO_REDO.commit_action()
	pass

var fail_arr : Array[BlokiNode] = []
var fix_loops = 0
func fix_fail():
	fix_loops += 1
	if fix_loops > 10:
		printerr("stack_overflow... exiting fixing deselecting nodes")
		return
	if fail_arr.size() < 1:
		print("fixed")
		return
	print("fixing chunk " + str(fail_arr))
	for a in fail_arr:
		if _recursive_commit(a):
			fail_arr.erase(a)
	fix_fail()

func _recursive_commit(a) -> bool:
	if a is BlokiNode:
		var _name = a.get_meta("old_name", "error")
		var nodepath = a.get_meta("old_path", ".")
		var parent = ApiNodes.CURRENT_TREE_ROOT.get_node_or_null(nodepath)
		if not parent:
			printerr(a.get_meta("old_path"))
			fail_arr.append(a)
			printerr(fail_arr)
			return false
		
		var oldname = a.name
		a.reparent(parent)
		parent.remove_child(a)
		a.name = oldname
		parent.add_child(a,true)
		
		a.name = _name
		a.is_selected = false
		a.un_select()
		
		
		
		var transformed_node = a
		var new_pos = a.position
		var new_rot = a.rotation
		var new_scal = a.scale
		var old_pos = transformed_node.get_meta("old_pos", transformed_node.position)
		var old_rot = transformed_node.get_meta("old_rot", transformed_node.rotation)
		var old_scal = transformed_node.get_meta("old_scal", transformed_node.size)
		ApiNodes.CURRENT_UNDO_REDO.add_do_method(func():
			transformed_node.position = new_pos
			transformed_node.rotation = new_rot
			transformed_node.scale = new_scal
			)
		ApiNodes.CURRENT_UNDO_REDO.add_undo_method(func():
			transformed_node.position = old_pos
			transformed_node.rotation = old_rot
			transformed_node.size = old_scal
			)
	return true
