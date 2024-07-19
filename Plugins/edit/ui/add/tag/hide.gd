extends TextureButton

func _toggled(toggled_on):
	$"../../VBoxContainer".visible = not toggled_on
	pass
