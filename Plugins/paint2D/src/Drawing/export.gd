extends Button

func _pressed() -> void:
	$FileDialog.popup_centered()
	pass

@export var canvas : DrawingCanvas

func _on_file_dialog_file_selected(path):
	var texture = canvas.save_image()
	if not is_instance_valid(texture): return
	if path.get_extension() == "png": texture.save_png(path)
	if path.get_extension() == "jpg": texture.save_jpg(path)
	pass
