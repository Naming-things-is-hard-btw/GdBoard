extends BlokiPlugin

var ui = preload("res://Plugins/paint2D/src/Drawing/drawing.tscn").instantiate()
var Tools = preload("res://Plugins/paint2D/src/autoload/tools.gd").new()
var Global = preload("res://Plugins/paint2D/src/autoload/Global.gd").new()

func _init() -> void:
	name = "paint2d"
	DependecyList = [
		"res://Plugins/global_plugins/keyboard_shortcuts/shortcuts.gd",
	]

func on_spawn():
	ui.plugin = self
	add_child(Tools, true)
	add_child(Global, true)
	Global.add_to_group("Paint2d_Global")
	Global.plugin = self
	Tools.add_to_group("Paint2d_Tools")
	get_ui_viewport().add_viewport(ui)
	register_as_tab("Draw", preload("res://theme/modern_icons/draw.svg"))
	undoredo.max_steps = 20
	Api.clear_history.connect(func():
		undoredo.clear_history()
		)
	pass

var undoredo : UndoRedo = UndoRedo.new()

func on_enable():
	ApiNodes.CURRENT_UNDO_REDO = undoredo
	Global.open.emit()
	get_ui_parent_leftpanel().set_panel_ratio(0)
	get_ui_parent_rightpanel().set_panel_ratio(0)
	get_ui_viewport().set_current_viewport(ui)
	get_ui_bottompanel().set_current_panel(null)
	get_ui_rightpanel().set_current_panel(null)
	get_ui_bottom_right_panel().set_current_panel(null)
	get_ui_leftpanel().set_current_panel(null)
	get_ui_bottom_left_panel().set_current_panel(null)
	pass

signal disabled
func on_disable():
	disabled.emit()
	pass
