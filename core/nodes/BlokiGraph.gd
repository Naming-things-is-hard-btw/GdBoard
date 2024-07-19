@tool
class_name BlokiGraph extends BlokiNode

var tex : TextureRect
@export var texture : Texture2D:
	set(new):
		texture = new
		tex.texture = new
@export var texture_rotation : float:
	set(new):
		texture_rotation = new
		tex.pivot_offset = tex.size/2.0
		tex.rotation_degrees = new


func _get_config(m : menu):
	var texture_selector = preload("res://core/nodes/dependencies/BlokiTexture/Texture_Select.tscn").instantiate()
	texture_selector._load(self)
	m.add_custom(texture_selector)
	m.add_float("Rotation", preload("res://theme/SVG/cycle.png"), "texture_rotation", self, 0, func():)
	super._get_config(m)

func _init():
	super._init()
	tex = TextureRect.new()
	add_child(tex, true, Node.INTERNAL_MODE_FRONT)
	tex.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tex.anchor_bottom = 1
	tex.anchor_left = 0
	tex.anchor_right = 1
	tex.anchor_top = 0
	tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	copy_list.append("texture")
	copy_list.append("texture_rotation")
	resized.connect(func():
		tex.pivot_offset = tex.size/2.0
		)
	pass

func _ready() -> void:
	tex.texture = texture
	tex.pivot_offset = tex.size/2.0
	tex.rotation_degrees = texture_rotation
	pass

func _duplicate() -> BlokiNode:
	var n = BlokiTexture.new()
	_copydata(n, true)
	for a in get_children():
		if a is BlokiNode:
			n.add_child( a._duplicate(), true )
	return n
