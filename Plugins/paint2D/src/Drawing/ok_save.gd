extends Button


func _pressed() -> void:
	var idx = $"../SpinBox".value
	var img = owner.canvas.save_image()
	Projects.current_project.texture_array[idx].set_image(img)
	$"../../..".hide()
	pass
