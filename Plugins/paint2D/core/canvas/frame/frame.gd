class_name DrawingFrame extends Control
@export var plugin : BlokiPlugin:
	set(new):
		plugin = new
		for a in vp.get_children():
			a.plugin = plugin

var current_image_index = 0
var customwidth
var customheight
var customcolor

@export var vp : SubViewport

@onready var panel = $Panel

func set_current_layer(idx : int):
	for a in vp.get_children():
		a.candraw = false
	var node
	if idx > -1: node = vp.get_child(idx)
	if not node: return
	node.candraw = true
	current_image_index = idx
	pass

func load_image(image : Image, idx = -1):
	if not image: return
	var node : DrawingImage
	if idx > -1: node = vp.get_child(idx)
	else:
		node = new_image(Color(0,0,0,0), true)
		set_current_layer(vp.get_child_count()-1)
	if not node: return
	node.iload(image)
	pass

func save_image(idx = -1) -> Image:
	var node
	if idx > -1: node = vp.get_child(idx)
	else:
		if current_image_index >= vp.get_child_count(): return
		node = get_child(current_image_index)
	if not node: return null
	return node.isave()

func save_frame() -> Image:
	return vp.get_texture().get_image()

func clear_frame():
	for a in vp.get_children():
		vp.remove_child(a)
	pass

func new_frame(_customwidth, _customheight, _customcolor):
	clear_frame()
	customwidth = _customwidth
	customheight = _customheight
	customcolor = _customcolor
	vp.size = Vector2(_customwidth, _customheight)
	panel.size = Vector2(customwidth, customheight)
	panel.position = -Vector2(customwidth, customheight) / 2
	$TextureRect.position = -Vector2(customwidth, customheight) / 2
	$TextureRect.size =  Vector2(customwidth, customheight)
	new_image(_customcolor,true)
	new_image(Color(0,0,0,0),true)
	set_current_layer(1)
	pass

func new_image(_color = Color(0,0,0,0), force_new : bool = false, idx = -1):
	var node
	if not force_new:
		if idx > -1: node = vp.get_child(idx)
		else:
			if current_image_index >= vp.get_child_count(): return
			node = vp.get_child(current_image_index)
	if not node or force_new:
		node = preload("res://Plugins/paint2D/core/canvas/frame/draw_image/image.scn").instantiate()
		node.plugin = plugin
		var undoredo = ApiNodes.CURRENT_UNDO_REDO
		if not is_instance_valid(undoredo):
			vp.add_child(node, true)
		else:
			undoredo.create_action("add")
			undoredo.add_do_method(func():
				vp.add_child(node, true)
				)
			undoredo.add_undo_method(func():
				vp.remove_child(node)
				)
			undoredo.commit_action()
		
		node.candraw = false
	node.inew(customwidth, customheight, _color)
	return node

func remove_layer(index : int):
	var undoredo = ApiNodes.CURRENT_UNDO_REDO
	var oldimageindex = current_image_index
	var idx = index
	var child = vp.get_child(idx)
	
	if not is_instance_valid(undoredo):
		vp.remove_child(child)
		current_image_index = oldimageindex - 1
		if current_image_index < 0: current_image_index = 0
		set_current_layer(current_image_index)
	else:
		
		undoredo.create_action("delete")
		undoredo.add_do_method(func():
			vp.remove_child(child)
			current_image_index = oldimageindex - 1
			if current_image_index < 0: current_image_index = 0
			set_current_layer(current_image_index)
			)
		undoredo.add_undo_method(func():
			vp.add_child(child)
			vp.move_child(child, idx)
			current_image_index = oldimageindex + 1
			if current_image_index >= vp.get_child_count(): current_image_index = vp.get_child_count()-1
			set_current_layer(current_image_index)
			)
		undoredo.commit_action()
	pass

func get_layer(index : int):
	return vp.get_child(index)

func move_layer_up(idx : int):
	var image = vp.get_child(idx)
	if not image: return
	vp.move_child(image, idx-1)
	set_current_layer(idx)

func move_layer_down(idx : int):
	var image = vp.get_child(idx)
	if not image: return
	vp.move_child(image, idx+1)
	set_current_layer(idx)
