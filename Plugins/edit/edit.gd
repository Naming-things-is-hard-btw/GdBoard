extends BlokiPlugin

var scene : Control = preload("res://Plugins/edit/ui/scene/Scene.tscn").instantiate()
var inspector : Control = preload("res://Plugins/edit/ui/inspector/Inspector.tscn").instantiate()
var fav : Control = preload("res://Plugins/edit/ui/fav/fav.tscn").instantiate()

var undoredo : UndoRedo = UndoRedo.new()

func _init() -> void:
	name = "edit"
	DependecyList = [
		"res://Plugins/edit/sub_plugins/add/add.gd",
		"res://Plugins/global_plugins/keyboard_shortcuts/shortcuts.gd",
		"res://Plugins/global_plugins/drag_select/drag_select.gd",
		"res://Plugins/global_plugins/select/select.gd",
		"res://Plugins/global_plugins/delete/delete.gd",
		"res://Plugins/global_plugins/duplicate/duplicate.gd",
		"res://Plugins/global_plugins/folder/folder.gd",
		"res://Plugins/global_plugins/move/move.gd",
		"res://Plugins/global_plugins/scale/scale.gd",
		"res://Plugins/global_plugins/show_grid/show_grid.gd",
		"res://Plugins/global_plugins/arrow/arrow.gd",
	]
	register_as_tab("Edit", preload("res://theme/modern_icons/edit.svg"))

func on_spawn() -> void:
	get_ui_rightpanel().add_panel(scene)
	get_ui_bottom_right_panel().add_panel(inspector)
	get_ui_rightpanel().add_panel(fav)
	undoredo.max_steps = 50
	Api.clear_history.connect(func():
		undoredo.clear_history()
		)
	Api.node_selected.connect(func(node):
		if ui_mode == 1:
			if node != null:
				get_ui_parent_leftpanel().set_panel_ratio(1)
				get_ui_leftpanel().set_current_panel(inspector, 1)
			else:
				get_ui_parent_leftpanel().set_panel_ratio(0)
				get_ui_leftpanel().set_current_panel(null)
		)
	pass

var ui_mode = 1
var selectable : SelectableButton

func on_enable():
	super.on_enable()
	ApiMem.edit_mode = true
	ApiNodes.CURRENT_UNDO_REDO = undoredo
	
	selectable = get_ui_tool_panel(UI_TOOL_MODE.RIGHT).add_selectable([
		preload("res://theme/icons/new_chevron_left_FILL0_wght400_GRAD0_opsz24.png"),
		preload("res://theme/icons/drag_select.png"),
		preload("res://theme/icons/root.png"),
	])
	selectable.select_option(ui_mode, false)
	selectable.option_selected.connect(func(opt):
		ui_mode = opt
		update_ui(true)
		)
	
	update_ui()
	var node = ApiNodes.SELECTED_NODE
	await get_tree().process_frame
	Api.select_node(node)
	pass

func update_ui(delay = false):
	get_ui_viewport().set_current_viewport(ApiNodes.UI_VIEWPORT)
	get_ui_bottom_right_panel().set_current_panel(null)
	match ui_mode:
		0:
			get_ui_parent_rightpanel().set_panel_ratio(0.8)
			get_ui_bottompanel().set_current_panel(null)
			get_ui_rightpanel().set_current_panel(scene, 1)
			get_ui_parent_leftpanel().set_panel_ratio(0)
			get_ui_leftpanel().set_current_panel(null)
			if delay: await get_tree().create_timer(0.2).timeout
			get_ui_bottom_right_panel().set_current_panel(inspector, 2)
		1:
			get_ui_parent_rightpanel().set_panel_ratio(0.45)
			get_ui_parent_leftpanel().set_panel_ratio(0)
			get_ui_rightpanel().set_current_panel(fav, 1)
			get_ui_bottompanel().set_current_panel(null)
			get_ui_leftpanel().set_current_panel(null)
			get_ui_bottom_left_panel().set_current_panel(null)
		2:
			get_ui_parent_rightpanel().set_panel_ratio(0.8)
			get_ui_bottompanel().set_current_panel(null)
			get_ui_rightpanel().set_current_panel(scene, 1)
			if delay: await get_tree().create_timer(0.2).timeout
			get_ui_parent_leftpanel().set_panel_ratio(1)
			get_ui_leftpanel().set_current_panel(inspector, 1)
