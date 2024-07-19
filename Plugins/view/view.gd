extends BlokiPlugin

func _init() -> void:
	name = "view"
	DependecyList = [
		"res://Plugins/global_plugins/show_grid/show_grid.gd",
	]
	register_as_tab("View", preload("res://theme/modern_icons/view.svg"))

func on_spawn() -> void:
	ApiNodes.UI_VIEWPORT = preload("res://Plugins/view/viewport/viewports.tscn").instantiate()
	get_ui_viewport().add_viewport(ApiNodes.UI_VIEWPORT)
	pass

func on_enable():
	super.on_enable()
	ApiMem.edit_mode = false
	get_ui_viewport().set_current_viewport(ApiNodes.UI_VIEWPORT)
	get_ui_parent_rightpanel().set_panel_ratio(0)
	get_ui_parent_leftpanel().set_panel_ratio(0)
	get_ui_rightpanel().set_current_panel(null)
	get_ui_bottom_right_panel().set_current_panel(null)
	get_ui_bottompanel().set_current_panel(null)
	get_ui_leftpanel().set_current_panel(null)
	get_ui_bottom_left_panel().set_current_panel(null)
	var node = null
	await get_tree().process_frame
	Api.select_node(node)
	ApiNodes.CURRENT_UNDO_REDO = null
	pass 
