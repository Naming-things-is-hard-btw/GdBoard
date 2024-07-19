extends Button


func _pressed() -> void:
	var node = ApiNodes.SELECTED_NODE
	if not is_instance_valid(node): return
	if node is BlokiTexture:
		node.texture = ImageTexture.create_from_image(owner.canvas.save_image())
		owner.do_not_popup = true
		ApiNodes.Plugins.select_plugin("edit")
		owner.do_not_popup = false
	pass
