extends VBoxContainer
class_name Tag

func search(word: String):
	if word == "":
		for a in $VBoxContainer.get_children():
			a.visible = true
		return
	for a in $VBoxContainer.get_children():
		if (a.text as String).find(word) != -1:
			a.visible = true
		else:
			a.visible = false
		pass
	pass

func add(control : Control):
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	$VBoxContainer.add_child(control)
	pass

func _ready():
	$Tag/Label.text = name
