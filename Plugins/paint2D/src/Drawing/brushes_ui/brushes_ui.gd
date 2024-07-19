extends Control
@export var box : Control

signal done

func Update():
	clear_buttons()
	for brush in get_tree().get_nodes_in_group("Paint2d_Tools")[0].brushes_array:
		add_button(brush["icon"]).pressed.connect(func():
			get_tree().get_nodes_in_group("Paint2d_Tools")[0].changeTool(brush["toolname"])
			done.emit()
			)
	pass

func clear_buttons():
	for a in box.get_children():
		a.queue_free()
	pass

func add_button(icon : Texture2D) -> Button:
	var button = Button.new()
	button.custom_minimum_size = Vector2(30,30)
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	button.expand_icon = true
	#button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	button.icon = icon
	box.add_child(button, true)
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	return button
