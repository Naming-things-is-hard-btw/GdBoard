extends MarginContainer
class_name ToolPanel
var box : BoxContainer

enum ori{
	vertical,
	horizontal
}

@export var Rotation : ori = ori.horizontal

func _ready():
	box = $box
	pass

func clear_buttons():
	for a in box.get_children():
		a.queue_free()
	pass

func add_button(icon : Texture2D) -> Button:
	var button = Button.new()
	button.icon = icon
	button.theme = preload("res://theme/mctheme_noscroll.tres")
	box.add_child(button, true)
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	return button

func add_selectable(icons : Array[Texture2D]) -> SelectableButton:
	var selectable = preload("res://core/utility/panels/tool_panel/selectable_button.tscn").instantiate()
	box.add_child(selectable, true)
	selectable.load_options(icons, Rotation)
	return selectable
