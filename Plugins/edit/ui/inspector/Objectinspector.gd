extends VBoxContainer

func _ready():
	Api.node_selected.connect(_update)
	_update(null)
	pass

func _update(object : BlokiNode):
	var m : menu = $MarginContainer/TabContainer/inspector/HFlowContainer
	m.clear()
	if is_instance_valid(object):
		object._get_config(m)
	pass
