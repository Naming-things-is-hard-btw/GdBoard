extends LineEdit

@export var scene_container : Control

func _on_text_changed(new_text):
	for a in scene_container.get_children():
		if a is Tag:
			a.search(new_text)
	pass
