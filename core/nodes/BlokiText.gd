@tool
class_name BlokiText extends BlokiNode

@export var text : String:
	set(new):
		text = new
		label.text = text
@export var text_size : int:
	set(new):
		text_size = new
		label.add_theme_font_size_override("font_size", new)
@export var text_color : Color = Color.WHITE:
	set(new):
		text_color = new
		label.add_theme_color_override("font_color", new)
@export var autowarp = false:
	set(new):
		autowarp = new
		if autowarp: label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		else: label.autowrap_mode = TextServer.AUTOWRAP_OFF
@export var h_allign = 0:
	set(new):
		h_allign = new
		label.horizontal_alignment = h_allign
@export var v_allign = 0:
	set(new):
		v_allign = new
		label.vertical_alignment = v_allign

var label = Label.new()
var scroll = ScrollContainer.new()

func _get_config(m : menu):
	m.add_string("Text", preload("res://theme/icons/new_menu_FILL0_wght400_GRAD0_opsz24.png"), "text", self, "text", func():)
	m.add_int("Text Size", preload("res://theme/icons/new_sort_FILL0_wght400_GRAD0_opsz24.png"), "text_size", self, 25, func():)
	m.add_color("Text Color", null, "text_color", self, Color.WHITE, func():)
	var inst = preload("res://core/nodes/dependencies/BlokiText/text_mode.tscn").instantiate()
	inst._load(self)
	m.add_custom(inst)
	super._get_config(m)

func _init():
	super._init()
	add_child(scroll, true, Node.INTERNAL_MODE_BACK)
	scroll.add_child(label, true, Node.INTERNAL_MODE_BACK)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.vertical_alignment = v_allign
	label.horizontal_alignment = h_allign
	if autowarp: label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	else: label.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	if ApiMem.edit_mode: scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else: scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	
	scroll.anchor_bottom = 1
	scroll.anchor_left = 0
	scroll.anchor_right = 1
	scroll.anchor_top = 0
	
	copy_list.append("text")
	copy_list.append("text_size")
	copy_list.append("text_color")
	copy_list.append("autowarp")
	copy_list.append("h_allign")
	copy_list.append("v_allign")
	
	Api.edit_mode_change.connect(func():
		if ApiMem.edit_mode:
			scroll.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			scroll.mouse_filter = Control.MOUSE_FILTER_PASS
		)

func _duplicate() -> BlokiNode:
	var n = BlokiText.new()
	_copydata(n, true)
	for a in get_children():
		if a is BlokiNode:
			n.add_child( a._duplicate(), true )
	return n
