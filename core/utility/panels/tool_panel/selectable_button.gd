class_name SelectableButton extends PanelContainer

@onready var box = $HBoxContainer

signal option_selected(index)

func select_option(index : int, emitsignal : bool = true):
	for a in box.get_children():
		if a is Button:
			a.button_pressed = (a.get_index() == index)
			a.flat = not (a.get_index() == index)
		pass
	if emitsignal: option_selected.emit(index)
	pass

func load_options(textures : Array[Texture2D], ori : ToolPanel.ori):
	box.vertical = (ori == ToolPanel.ori.vertical)
	for texture in textures:
		var button = Button.new()
		button.theme = preload("res://theme/mctheme_noscroll.tres")
		button.icon = texture
		button.flat = true
		box.add_child(button, true)
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		button.toggle_mode = true
		button.pressed.connect(func():
			select_option(button.get_index())
			)
		pass
	pass
