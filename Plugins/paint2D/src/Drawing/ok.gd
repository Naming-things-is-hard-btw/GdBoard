extends Button


func _pressed() -> void:
	var idx = $"../SpinBox".value
	owner.canvas.load_image(Projects.current_project.texture_array[idx].get_image())
	$"../../..".hide()
	pass
