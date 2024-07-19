extends BlokiPlugin


var grid : Control = preload("res://Plugins/projects/ui/projects_menu/Projects_menu.tscn").instantiate()

func on_spawn() -> void:
	get_ui_viewport().add_viewport(grid)

func on_destruct():
	grid.queue_free()

func _init() -> void:
	name = "project"
	DependecyList = ["res://Plugins/projects/project_UI_init.gd"]
	register_as_tab("Projects", preload("res://theme/modern_icons/folder.svg"), false)
	pass

func on_enable():
	super.on_enable()
	ApiNodes.CURRENT_UNDO_REDO = null
	Api.select_node(null)
	get_ui_viewport().set_current_viewport(grid)
	get_ui_leftpanel().set_current_panel(null)
	get_ui_bottom_left_panel().set_current_panel(null)
	get_ui_bottom_right_panel().set_current_panel(null)
	get_ui_parent_rightpanel().set_panel_ratio(0)
	get_ui_parent_leftpanel().set_panel_ratio(0)
	get_ui_rightpanel().set_current_panel(null)
	get_ui_bottompanel().set_current_panel(null)
	pass 
