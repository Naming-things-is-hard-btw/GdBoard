extends Control

var B_object
var update
var variable_name : String
var default = false
func _setup(node, variable : String, icon = null, Text = "", updateobj = null, _default = false):
	default = _default
	update = updateobj
	$c/title/Control/c/icon.icon = icon
	B_object = node
	variable_name = variable
	$c/title/Control/c/ScrollContainer/name.text = Text

func _update():
	if B_object == null: return
	if not is_instance_valid(B_object): return
	$c/main/VBoxContainer/x/CheckButton.button_pressed = B_object.get(variable_name)
	pass

var old
func _process(_delta):
	if not is_instance_valid(B_object): return
	if B_object.get(variable_name) != old:
		_update()
		pass
	old = B_object.get(variable_name)
	pass

func _on_reset_pressed():
	B_object.set(variable_name, default)
	if is_instance_valid(update):
		if update.has_method("_update"):
			update._update()
	pass

func _on_check_button_toggled(toggled_on):
	if B_object == null: return
	B_object.set(variable_name, toggled_on)
	if is_instance_valid(update):
		if update.has_method("_update"):
			update._update()
	pass
