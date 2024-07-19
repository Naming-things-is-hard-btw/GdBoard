extends PanelContainer

var do_not_popup = false

func _ready() -> void:
	if get_tree().get_nodes_in_group("Paint2d_Global")[0].drawing_control:
		return
	get_tree().get_nodes_in_group("Paint2d_Global")[0].drawing_control = self
	canvas.new_image(400, 200, Color.WHITE)
	
	ApiNodes.Plugins.on_selecting.connect(func(_a):
		await get_tree().process_frame
		if not plugin.is_enabled(): return
		var newnode = ApiNodes.SELECTED_NODE
		if newnode is BlokiTexture:
			$Control/selectnode.hide()
			var img = newnode.texture.get_image()
			canvas.new_image(img.get_size().x, img.get_size().y, Color.WHITE)
			canvas.load_image(img)
			canvas.frame.remove_layer(0)
			canvas.frame.remove_layer(0)
		else:
			canvas.frame.clear_frame()
			$Control/selectnode.show()
		)
	plugin.disabled.connect(func():
		node = ApiNodes.SELECTED_NODE
		tex = ImageTexture.create_from_image(canvas.save_image())
		if not is_instance_valid(node): return
		if node is BlokiTexture:
			if do_not_popup: return
			var inst = preload("res://Plugins/paint2D/src/Drawing/should_save.tscn").instantiate()
			get_tree().root.add_child(inst)
			inst.popup_centered()
			inst.canceled.connect(func():
				inst.queue_free()
				)
			inst.confirmed.connect(func():
				node.texture = tex
				)
		)
	Projects.save_proj.connect(func():
		if not plugin.is_enabled(): return
		var _node = ApiNodes.SELECTED_NODE
		var _tex = ImageTexture.create_from_image(canvas.save_image())
		if not is_instance_valid(_node): return
		if _node is BlokiTexture:
			_node.texture = _tex
		do_not_popup = true
		ApiNodes.Plugins.select_plugin("edit")
		do_not_popup = false
		)


var node
var tex

@export var canvas : DrawingCanvas
var plugin : BlokiPlugin

func _on_control_create(_size, color):
	canvas.new_image(_size.x, _size.y, color)
	pass
