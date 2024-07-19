@tool
extends Node

## emitted everytime a node is selected
signal node_selected(new_node : BlokiNode)
signal update_world()
signal change_mode()
signal clear_history()
signal forward_input(event)
signal virtual_mouse_right_click(pos : Vector2, state)
enum mouse_input_state{
	pressed,
	canceled,
	draging,
	done
}
signal edit_mode_change()
var console : BlokiConsole

func activate_on_tree(tree_root : Node, function : Callable):
	for a in tree_root.get_children():
		function.call(a)
		activate_on_tree(a, function)
		pass
	pass

func loading_show():
	get_node("/root/main/loading").show()
func loading_hide():
	get_node("/root/main/loading").hide()

func _ready(): OS.request_permissions()

func export_unwarp():
	change_type(ApiNodes.CURRENT_TREE_ROOT, get_node("/root/main/Export"))
func get_export():
	return get_node("/root/main/Export")
func export_cleanup():
	for a in get_node("/root/main/Export").get_children():
		a.queue_free()

func change_type(node, otherroot):
	for a in node.get_children():
		if a is BlokiNode:
			var othernode = (a as BlokiNode).export_mode()
			if is_instance_valid(othernode):
				otherroot.add_child(othernode, true)
				change_type(a, othernode)
	pass


func select_node(blokinode : BlokiNode, emitsignal : bool = true) -> bool:
	ApiNodes.SELECTED_NODE = blokinode
	if is_instance_valid(ApiNodes.OLD_SELECTED_NODE):
		ApiNodes.OLD_SELECTED_NODE.un_select()
	if is_instance_valid(blokinode):
		blokinode.select()
	if emitsignal: node_selected.emit(blokinode)
	ApiNodes.OLD_SELECTED_NODE = blokinode
	return is_instance_valid(blokinode)
