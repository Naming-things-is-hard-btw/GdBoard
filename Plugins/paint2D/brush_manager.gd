class_name BrushManager extends Node

signal on_tool_update()
signal canvas_input(event)

var brushes_array : Array
var current_tool : String = ""
var drawing = false

var current_root : Node2D
var current_preview : TextureRect
var current_old_image : TextureRect

var is_allowed_to_cancel : bool = true

func changeTool(tool_name):
	current_tool = tool_name
	on_tool_update.emit()
	pass

func load_gd_tool(toolpath : String):
	var script = ResourceLoader.load(toolpath,"GDScript",ResourceLoader.CACHE_MODE_IGNORE)
	add_child(script.new())
	on_tool_update.emit()
	pass

func load_tool(tool : DrawingBrush):
	if get_child_count() == 0: current_tool = tool.name
	add_child(tool, true)
	var toolname = tool.name
	brushes_array.append({"toolname": toolname, "icon": tool.get_icon()})
	pass

func get_tools() -> Array[Node]:
	return get_children()

func get_current_tool() -> DrawingBrush:
	return get_node_or_null(current_tool)




func use_mouse() -> bool:
	var tool = get_node_or_null(current_tool)
	if tool == null: return false
	if not tool.has_method("use_mouse"): return false
	return tool.use_mouse()

func start(pos : Vector2 , root : Node2D, oldimage, preview):
	if drawing: return
	drawing = true
	current_old_image = oldimage
	current_preview = preview
	current_root = root
	var tool = get_node_or_null(current_tool)
	if tool == null: return
	if not tool.has_method("start"): return
	tool.start(pos, root, preview, oldimage)
	pass

func update(pos):
	if not drawing: return
	var tool = get_node_or_null(current_tool)
	if tool == null: return
	if not tool.has_method("update"): return
	tool.update(pos)
	pass

func stop():
	if not drawing: return
	drawing = false
	var tool = get_node_or_null(current_tool)
	if tool == null: return
	if not tool.has_method("stop"): return
	tool.stop()
	pass

func cancel():
	if not drawing: return
	drawing = false
	var tool = get_node_or_null(current_tool)
	if tool == null: return
	if not tool.has_method("cancel"): return
	tool.cancel()
	pass
