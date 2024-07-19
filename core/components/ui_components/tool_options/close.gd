extends Button

func _pressed() -> void:
	owner.hide()
	$"../../../../ScrollContainer/menu".clear()
	pass

