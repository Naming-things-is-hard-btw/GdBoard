extends Button


func _pressed():
	$FileDialog.popup_centered()
	pass
@export var canvas : DrawingCanvas

func _on_file_dialog_file_selected(path):
	var img = Image.load_from_file(path)
	canvas.load_image(img)
	pass
