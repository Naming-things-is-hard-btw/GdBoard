extends Control

var B_object
var variable_name : String
var update
func _setup(node, variable : String, Text, updateobj, _default):
	B_object = node
	update = updateobj
	variable_name = variable
	$color/Panel/name.text = Text

func _process(_delta):
	if not B_object: return
	$color/ColorPickerButton.color = B_object.get(variable_name)
	pass

func _on_ColorPickerButton_color_changed(color):
	if B_object == null: return
	B_object.set(variable_name, color)
	if is_instance_valid(update):
		if update.has_method("_update"):
			update._update()
	pass # Replace with function body.
