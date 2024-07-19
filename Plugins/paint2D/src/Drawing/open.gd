extends Button


func _pressed():
	$FileDialog.popup_centered()
	pass
@export var canvas : DrawingCanvas

func _on_file_dialog_file_selected(path):
	var img = Image.load_from_file(path)
	canvas.new_image(img.get_size().x, img.get_size().y, Color.WHITE)
	canvas.load_image(img)
	pass
