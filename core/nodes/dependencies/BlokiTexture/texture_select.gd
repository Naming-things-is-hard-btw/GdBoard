extends BoxContainer

var blokitex_ref : BlokiTexture
func _load(tex : BlokiTexture):
	blokitex_ref = tex
	$OptionButton.select(blokitex_ref.texture_stretch)
	pass

func _on_select_pressed() -> void:
	$import_filedialog.show()
	pass

func _on_edit_pressed() -> void:
	Api.select_node(blokitex_ref)
	ApiNodes.Plugins.select_plugin("paint2d")
	pass

func _on_export_pressed() -> void:
	$export_filedialog.show()
	pass


func _on_export_filedialog_file_selected(path: String) -> void:
	var texture = blokitex_ref.texture
	if not is_instance_valid(texture): return
	if path.get_extension() == "png": texture.get_image().save_png(path)
	if path.get_extension() == "jpg": texture.get_image().save_jpg(path)
	pass


func _on_import_filedialog_file_selected(path: String) -> void:
	var img = Image.load_from_file(path)
	var tex = ImageTexture.create_from_image(img)
	blokitex_ref.texture = tex
	pass


func _on_option_button_item_selected(index: int) -> void:
	blokitex_ref.texture_stretch = index
