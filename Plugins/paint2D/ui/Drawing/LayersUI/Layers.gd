extends Control

@export var tree : Tree
@export var drawing_panel : DrawingFrame

func _ready():
	(get_parent() as Popup).about_to_popup.connect(Update)
	pass


func Update():
	tree.clear()
	var root = tree.create_item()
	if not root: return
	root.set_text(1, "Frame")
	var frame = drawing_panel
	var layers = frame.vp.get_children()
	tree.set_column_expand(0,false)
	tree.set_column_expand(1,true)
	tree.set_column_expand(2,false)
	tree.set_column_expand(3,false)
	for i in range(layers.size()):
		var a = layers[i]
		if a is DrawingImage:
			var item = tree.create_item(root)
			#1 (info)
			item.set_icon(1, ImageTexture.create_from_image(a.isave()))
			item.set_icon_max_width(1,100)
			item.set_text(1, str(i))
			item.set_metadata(1, i )
			if i == frame.current_image_index:
				item.set_custom_bg_color(1, Color(0,0.3,0.5));
			#0 (visibility)
			
			if a.visible:
				item.add_button(0, preload("res://theme/icons/visibility_on.png"))
			else:
				item.add_button(0, preload("res://theme/icons/visibility_off.png"))
			item.add_button(2, preload("res://theme/icons/up.png"))
			item.add_button(3, preload("res://theme/icons/down.png"))
			pass
		pass
	$"BoxContainer/BoxContainer2/PanelContainer/BoxContainer/transparency slider".Update()
	pass


func _on_add_layer_pressed():
	var frame = drawing_panel
	frame.new_image(Color(0,0,0,0), true)
	Update()
	pass


func _on_remove_layer_pressed():
	var frame = drawing_panel
	frame.remove_layer(frame.current_image_index)
	Update()
	pass


func _on_tree_node_selected():
	var item = tree.get_selected()
	var frame = drawing_panel
	var idx = item.get_metadata(1)
	if idx is int:
		frame.set_current_layer(idx)
	await get_tree().process_frame
	Update()
	pass


func _on_tree_button_clicked(item : TreeItem, column, id, mouse_button_index):
	var frame = drawing_panel
	var idx = item.get_metadata(1)
	if not idx is int: return
	match column:
		0: # visibility
			var image = frame.get_layer(idx)
			if not image: return
			image.visible = not image.visible
		2: frame.move_layer_up(idx)
		3: frame.move_layer_down(idx)
	await get_tree().process_frame
	Update()
	pass


func _on_tree_item_selected() -> void:
	_on_tree_node_selected()
