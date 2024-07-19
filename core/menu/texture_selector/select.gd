extends MenuButton

func _ready():
	get_popup().index_pressed.connect(func(idx):
		var texture_arr : Array[Texture2D] = Projects.current_project.texture_array as Array[Texture2D]
		owner.on_value_changed(texture_arr[idx])
		pass)
	pass

func _pressed():
	get_popup().clear()
	var texture_arr : Array[Texture2D] = Projects.current_project.texture_array as Array[Texture2D]
	for a in range(texture_arr.size()):
		var img = texture_arr[a].get_image()
		img.resize(80,80)
		get_popup().add_icon_item(ImageTexture.create_from_image(img), str(a))
		pass
	pass
