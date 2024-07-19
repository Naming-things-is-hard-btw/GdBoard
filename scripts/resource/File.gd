class_name GraphFile extends GraphDataItem

@export var title : String = "File"
@export var file_name : String
@export var buffers : PackedByteArray

func _construct(editor : GraphEditor):
	return null

func _init() -> void:
	size = Vector2(400, 200)
	pass
