@tool
class_name BlokiNodePanel extends BlokiNode

var panel : Panel = Panel.new()
@export var stylebox : StyleBoxFlat = StyleBoxFlat.new()
@export var corner_radius : Vector4 = Vector4():
	set(new):
		corner_radius = new
		stylebox.corner_radius_top_left = new.x
		stylebox.corner_radius_top_right = new.y
		stylebox.corner_radius_bottom_left = new.z
		stylebox.corner_radius_bottom_right = new.w


func _get_config(m : menu):
	m.add_color("Color", null, "bg_color", stylebox, Color.WHITE, func():)
	m.add_vector4("Corner Radius", preload("res://theme/icons/material.png"), "corner_radius", self, Vector4(), func():)
	super._get_config(m)

func _init():
	super._init()
	add_child(panel, true, Node.INTERNAL_MODE_FRONT)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.anchor_bottom = 1
	panel.anchor_left = 0
	panel.anchor_right = 1
	panel.anchor_top = 0
	copy_list.append("stylebox")
	copy_list.append("corner_radius")
	pass

func _ready() -> void:
	panel.add_theme_stylebox_override("panel", stylebox)
	pass

func _duplicate() -> BlokiNode:
	var n = BlokiNodePanel.new()
	_copydata(n, true)
	for a in get_children():
		if a is BlokiNode:
			n.add_child( a._duplicate(), true )
	return n
