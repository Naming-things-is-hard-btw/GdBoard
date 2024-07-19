class_name MainViewportWidow
extends Control

func _init():
	ApiNodes.UI_VIEWPORT_WINDOW = self
	pass

func add_viewport(control):
	var b = $Control/Viewport
	b.add_panel(control)
	pass

func set_current_viewport(newtab : Control):
	var b = $Control/Viewport
	b.set_current_panel(newtab, 4)
	pass

func get_current_viewport():
	var b = $Control/Viewport
	return b.get_current_panel()

func _ready() -> void:
	ApiNodes.UI_TOOL_PANEL_DOWN = %down
	ApiNodes.UI_TOOL_PANEL_LEFT = %left
	ApiNodes.UI_TOOL_PANEL_RIGHT = %right
	ApiNodes.UI_TOOL_PANEL_UP = %up
	pass
