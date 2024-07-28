extends HSlider


func Update():
	var frame = owner.drawing_panel
	var idx = frame.current_image_index
	if not idx is int: return
	var image = frame.get_layer(idx) as TextureRect
	if not image: return
	value = image.modulate.a * 100.0
	pass

func _on_value_changed(value):
	var frame = owner.drawing_panel
	var idx = frame.current_image_index
	if not idx is int: return
	var image = frame.get_layer(idx) as TextureRect
	if not image: return
	image.modulate.a = value / 100.0
	pass
