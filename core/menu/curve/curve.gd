extends PanelContainer

var editing = false

var B_object
var update
var default
var variable_name : String
func _setup(node, variable : String, icon = null, Text = "", updateobj = null, _default = Vector3(0,0,0)):
	update = updateobj
	default = _default
	$c/title/Control/c/icon.icon = icon
	B_object = node
	variable_name = variable
	$c/title/Control/c/ScrollContainer/name.text = Text
	pass

@export var curve : Control

var old
func _process(_delta):
	if B_object.get(variable_name) != old:
		curve.update(B_object.get(variable_name))
		pass
	old = B_object.get(variable_name)
	pass

func on_value_changed(value):
	if B_object == null: return
	B_object.set(variable_name, value)
	
	curve.update(value)
	
	if is_instance_valid(update):
		if update.has_method("_update"):
			update._update()
	pass


