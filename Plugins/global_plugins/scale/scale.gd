extends BlokiPlugin

var scale_controls = preload("res://Plugins/global_plugins/scale/controls/scale_controls.tscn").instantiate()

func _init() -> void:
	name = "scale"

func on_spawn():
	ApiNodes.Plugins_vp.add_child(scale_controls, true)
	
	Api.node_selected.connect(func(a):
		if not is_enabled():
			scale_controls.select_node(null)
			return
		scale_controls.select_node(a)
		)
	pass
