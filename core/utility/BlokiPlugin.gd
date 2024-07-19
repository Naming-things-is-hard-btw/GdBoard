extends Node
class_name BlokiPlugin

@export var DependecyList : Array[String] = []

func _ready() -> void:
	reload_dependencies()

func reload_dependencies():
	for pluginLib in DependecyList:
		var inst = load(pluginLib).new()
		add_plugin(inst, true)
		pass
	pass

var enabled = false
func enable():
	enabled = true
	on_enable()
	for a in get_children():
		if a is BlokiPlugin: a.enable()
	pass
func disable():
	enabled = false
	on_disable()
	for a in get_children():
		if a is BlokiPlugin: a.disable()
	pass

func is_enabled() -> bool:
	return enabled

func destruct():
	on_destruct()
	for a in get_children():
		a.destruct()
	queue_free()
	pass

func clear_Plugins():
	for a in get_children():
		if a is BlokiPlugin:
			a.destruct()

func get_plugin_idx(index : int) -> BlokiPlugin:
	return get_child(index) as BlokiPlugin
func get_plugin(p_name : String) -> BlokiPlugin:
	return get_node_or_null(p_name) as BlokiPlugin
func get_plugins() -> Array:
	return get_children()

func add_plugin(node : BlokiPlugin, override = false):
	if not node: return
	var oldnode = get_node_or_null(NodePath(node.name))
	if is_instance_valid(oldnode):
		if override:
			printerr("PLUGIN_ALREADY_EXISTS!!!  " + node.name + "OVERRIDING...")
			oldnode.queue_free()
		else:
			printerr("PLUGIN_ALREADY_EXISTS!!!  " + node.name)
			return
	add_child(node,true)
	node.on_spawn()

func get_ui_parent_leftpanel() -> BlokiPanelParent:
	return ApiNodes.UI_LEFT_PANEL_PARENT as BlokiPanelParent
func get_ui_parent_rightpanel() -> BlokiPanelParent:
	return ApiNodes.UI_RIGHT_PANEL_PARENT as BlokiPanelParent
func get_ui_leftpanel() -> BlokiPanel:
	return ApiNodes.UI_LEFT_PANEL as BlokiPanel
func get_ui_rightpanel() -> BlokiPanel:
	return ApiNodes.UI_RIGHT_PANEL as BlokiPanel
func get_ui_bottompanel() -> BlokiPanel:
	return ApiNodes.UI_BOTTOM_PANEL as BlokiPanel
func get_ui_bottom_left_panel() -> BlokiPanel:
	return ApiNodes.UI_BOTTOM_LEFT_PANEL as BlokiPanel
func get_ui_bottom_right_panel() -> BlokiPanel:
	return ApiNodes.UI_BOTTOM_RIGHT_PANEL as BlokiPanel
func get_ui_viewport() -> MainViewportWidow:
	return ApiNodes.UI_VIEWPORT_WINDOW

enum UI_TOOL_MODE
{
	UP,
	LEFT,
	RIGHT,
	DOWN,
}
func get_ui_tool_panel(mode : UI_TOOL_MODE) -> ToolPanel:
	match mode:
		UI_TOOL_MODE.UP:
			return ApiNodes.UI_TOOL_PANEL_UP as ToolPanel
		UI_TOOL_MODE.LEFT:
			return ApiNodes.UI_TOOL_PANEL_LEFT as ToolPanel
		UI_TOOL_MODE.RIGHT:
			return ApiNodes.UI_TOOL_PANEL_RIGHT as ToolPanel
		UI_TOOL_MODE.DOWN:
			return ApiNodes.UI_TOOL_PANEL_DOWN as ToolPanel
	return null


func get_ui_tabs_panel() -> TabsPanel:
	return ApiNodes.UI_TABS as TabsPanel
func get_plugin_root() -> BlokiPlugin:
	return ApiNodes.Plugins
func get_ui_options() -> Options:
	return ApiNodes.UI_OPTIONS



func on_enable():
	pass
func on_disable():
	pass
func on_select():
	pass
func on_deselect():
	pass
func on_reselect():
	pass
func on_spawn():
	pass
func on_destruct():
	if is_tab: tab_button.queue_free()
	pass


signal on_selecting(p_name)
var is_selected : bool = false
var selected_plugin : String
func select_plugin(plugin_name : StringName):
	selected_plugin = plugin_name
	on_selecting.emit(plugin_name)
	for plugin in get_plugins():
		if plugin is BlokiPlugin:
			if plugin.name == plugin_name:
				if plugin.is_selected: plugin.on_reselect()
				plugin.is_selected = true
				plugin.on_select()
				if plugin.is_tab:
					get_ui_tool_panel(UI_TOOL_MODE.UP).clear_buttons()
					get_ui_tool_panel(UI_TOOL_MODE.LEFT).clear_buttons()
					get_ui_tool_panel(UI_TOOL_MODE.RIGHT).clear_buttons()
					get_ui_tool_panel(UI_TOOL_MODE.DOWN).clear_buttons()
					plugin.enable()
			else:
				if plugin.is_selected:
					plugin.is_selected = false
					plugin.on_deselect()
				if plugin.is_tab:
					if plugin.is_enabled():
						plugin.disable()
		pass
	pass

func get_parent_plugin() -> BlokiPlugin:
	var inst = get_parent()
	if inst is BlokiPlugin:
		return inst
	return null

var tab_button : Button
var is_tab : bool = false
func register_as_tab(tabname : String, icon : Texture2D, project_owned = true):
	tab_button = get_ui_tabs_panel().add_button(icon, tabname)
	is_tab = true
	tab_button.set_meta("project_owned", project_owned)
	tab_button.set_meta("owner_plugin", self)
	tab_button.connect("pressed", func():
		if not Projects.is_project_open and project_owned: return
		get_parent_plugin().select_plugin(name))
	get_ui_tabs_panel().add_child(tab_button, true)
	pass

func remove_plugin(tool_name : String):
	var plugin = get_plugin(tool_name)
	if not plugin: return
	plugin.destruct()
