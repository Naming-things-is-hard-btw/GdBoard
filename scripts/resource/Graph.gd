class_name Graph extends GraphDataItem


@export var graph_name : String = "new graph"
@export var camera_position : Vector2
@export var camera_scale : float = 1
@export var icon : Texture2D
@export var children : Array[GraphDataItem]
@export var locked = false

func _construct(editor : GraphEditor):
	return null

func _init() -> void:
	size = Vector2(400, 200)
	pass
