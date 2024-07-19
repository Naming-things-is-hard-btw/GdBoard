extends Button

func _pressed():
	$Window.show()

@export var canvas : DrawingCanvas
func _on_control_create(_size, col):
	canvas.new_image(_size.x, _size.y, col)
	pass
