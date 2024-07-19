extends PanelContainer

var fav_array : Array[ItemGroup]
@onready var hbox : Control = $BoxContainer/ScrollContainer/HBoxContainer

func _update():
	fav_array.clear()
	var loader = ApiMem.addnode_data
	var custom = ApiMem.custom_addnode_data
	for i in range(loader.array.size()+custom.array.size()):
		var builtin = not i >= loader.array.size()
		var data : ItemGroup 
		if builtin: data = loader.array[i]
		else: data = custom.array[i-loader.array.size()]
		var add_to_favlist = data.is_in_favorates
		if data.built_in:
			if not custom.built_in_favorates.has(i):
				custom.built_in_favorates[i] = false
			add_to_favlist = custom.built_in_favorates[i]
		if add_to_favlist:
			fav_array.append(data)
	
	for a in hbox.get_children():
		a.queue_free()
	for i in range(fav_array.size()):
		var button = preload("res://Plugins/edit/ui/fav/preview.tscn").instantiate()
		button.text = fav_array[i].item_name
		$spawner.set_current(fav_array[i], false)
		$spawner/SubViewport.render_target_update_mode = Viewport.VRS_UPDATE_ONCE
		await get_tree().process_frame
		await get_tree().process_frame
		var image = $spawner/SubViewport.get_texture().get_image()
		button.icon = ImageTexture.create_from_image(image)
		button.data = fav_array[i]
		hbox.add_child(button)
	for i in range(5):
		var button = preload("res://Plugins/edit/ui/fav/preview.tscn").instantiate()
		button.text = ""
		button.icon = null
		hbox.add_child(button)
	pass

func _ready() -> void:
	ApiMem.favorates_update.connect(_update)
	await get_tree().process_frame
	_update()
