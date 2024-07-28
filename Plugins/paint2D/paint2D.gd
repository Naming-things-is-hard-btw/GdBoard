class_name Paint2D extends BlokiPlugin

var ui : DrawUI = preload("res://Plugins/paint2D/ui/Drawing/drawing.tscn").instantiate()
var inspector : DrawInspector = preload("res://Plugins/paint2D/ui/inspector/Inspector.tscn").instantiate()
var drawing_canvas : DrawingCanvas
var brush_manager = BrushManager.new()

var brush_color : Color = Color.BLACK
var brush_scale : int = 1
signal open()

func _init() -> void:
	name = "paint2d"
	DependecyList = [
		"res://Plugins/global_plugins/keyboard_shortcuts/shortcuts.gd",
	]
	ui.plugin = self

func on_spawn():
	add_child(brush_manager, true)
	inspector.plugin = self
	get_ui_viewport().add_viewport(ui)
	get_ui_leftpanel().add_panel(inspector)
	
	inspector.Menu.clear()
	inspector.Menu.add_color("Color", null, "brush_color", self, Color.BLACK, func():)
	
	register_as_tab("Draw", preload("res://theme/modern_icons/draw.svg"))
	undoredo.max_steps = 20
	Api.clear_history.connect(func():
		undoredo.clear_history()
		)
	pass

var undoredo : UndoRedo = UndoRedo.new()

func on_enable():
	ApiNodes.CURRENT_UNDO_REDO = undoredo
	open.emit()
	get_ui_parent_leftpanel().set_panel_ratio(1)
	get_ui_parent_rightpanel().set_panel_ratio(0)
	get_ui_viewport().set_current_viewport(ui)
	get_ui_bottompanel().set_current_panel(null)
	get_ui_rightpanel().set_current_panel(null)
	get_ui_bottom_right_panel().set_current_panel(null)
	get_ui_leftpanel().set_current_panel(inspector, 1)
	get_ui_bottom_left_panel().set_current_panel(null)
	pass

signal disabled
func on_disable():
	disabled.emit()
	pass
