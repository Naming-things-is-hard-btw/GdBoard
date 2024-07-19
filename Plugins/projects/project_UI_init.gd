extends BlokiPlugin

func on_spawn() -> void:
	Projects.open_proj.connect(open)
	Projects.close_proj.connect(close)
	await get_tree().process_frame
	get_plugin_root().select_plugin("project")
	pass

func _init() -> void:
	name = "project_ui_init"

func open():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	get_plugin_root().select_plugin("view")
	Api.select_node(null)
	pass

func close():
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	get_plugin_root().select_plugin("project")
	pass
