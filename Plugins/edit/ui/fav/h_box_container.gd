extends BoxContainer


func _ready() -> void:
	resized.connect(func():
		var _size = get_viewport_rect().size
		#horizontal mode
		if _size.x > _size.y:
			vertical = full_vertical
		#vertical mode
		if _size.y > _size.x:
			vertical = !full_vertical
		)
@export var full_vertical = false
