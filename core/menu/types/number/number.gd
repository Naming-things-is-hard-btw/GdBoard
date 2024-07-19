extends Control

var B_object
var update : Callable
var default
var variable_name : String
func _setup(node, variable : String, is_int, Text , icon, updateobj : Callable, _default = 0):
	B_object = node
	default = _default
	update = updateobj
	variable_name = variable
	$c/title/Control/c/icon.icon = icon
	$c/title/Control/c/ScrollContainer/name.text = Text
	$c/main/VBoxContainer/x/spin.rounded = is_int

func _process(_delta):
	if B_object == null: return
	$c/main/VBoxContainer/x/spin.value = B_object.get(variable_name)

func _on_value_changed(value):
	if B_object == null: return
	B_object.set(variable_name, value)
	update.call()
	pass


func _on_reset_pressed():
	if B_object == null: return
	B_object.set(variable_name, default)
	update.call()
	pass
