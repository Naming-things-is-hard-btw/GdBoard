class_name GraphText extends GraphDataItem

enum TextMode{
	NONE,
	WINDOW_FIT_TEXT,
	TEXT_FIT_WINDOW
}


@export var title : String = "new text"
@export var text : String = "test"
@export var textcolor : Color = Color.WHITE
@export var textsize : float = 26
@export var text_mode : TextMode = TextMode.NONE

func _init() -> void:
	size = Vector2(400, 200)
	pass

func _construct(editor : GraphEditor):
	return null
