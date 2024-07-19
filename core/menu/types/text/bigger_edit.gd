extends Button


func _pressed() -> void:
	$Window.show()
	$Window/PanelContainer/MarginContainer/VBoxContainer/text.text = $"../text".text
	pass

func _on_done_pressed() -> void:
	var txt = $Window/PanelContainer/MarginContainer/VBoxContainer/text.text
	$"../text".text = txt
	$"../text".text_changed.emit()
	$Window.hide()
	pass
