@tool
extends Node
##this is for anything stored in memory and can be shared between plugins 

##array of plugin paths
var PluginArr : Array[String] = [
	"res://Plugins/_tool_menu/tool_menu.gd",
	"res://Plugins/projects/project.gd",
	"res://Plugins/view/view.gd",
	"res://Plugins/edit/edit.gd",
	"res://Plugins/paint2D/paint2D.gd",
	]

var addnode_data : ItemGroupLoader
var custom_addnode_data : ItemGroupLoader
signal favorates_update()

##if camera can move or not
var camera_movement_enabled : bool = true

var animation_type = 5
var animation_speed : float = 1.0

var edit_mode = false:
	set(new):
		edit_mode = new
		Api.edit_mode_change.emit()

signal showgrid_update()
var show_grid = true:
	set(new):
		show_grid = new
		showgrid_update.emit()
