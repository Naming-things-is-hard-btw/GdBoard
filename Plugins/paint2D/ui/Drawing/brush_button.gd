extends Button

@export var brushes : Control

func _pressed() -> void:
	if brushes.visible:
		brushes._hide()
	else: brushes._show()
