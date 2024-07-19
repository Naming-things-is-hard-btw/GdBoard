class_name GraphImage extends GraphDataItem

@export var title : String = "my image"
@export var image : Texture2D

func _construct(editor : GraphEditor):
	return null

func _init() -> void:
	size = Vector2(400, 200)
	pass
