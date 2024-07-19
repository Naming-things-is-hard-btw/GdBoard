@tool
extends Node
## api nodes

## SELECTION
var SELECTED_NODE : BlokiNode
var OLD_SELECTED_NODE : BlokiNode

## CAMERA
var TouchCamera2D : TouchCamera

## WORLD ROOT
var CURRENT_TREE_ROOT : Node2D
var WORLD_MANAGER : WorldManager

## PLUGINS
var Plugins : BlokiPlugin
var Plugins_vp : Node2D

##################################### UI STUFF
## TOOL PANELS
var UI_TOOL_PANEL_UP : ToolPanel
var UI_TOOL_PANEL_LEFT : ToolPanel
var UI_TOOL_PANEL_RIGHT : ToolPanel
var UI_TOOL_PANEL_DOWN : ToolPanel
## PANELS
var UI_LEFT_PANEL : BlokiPanel
var UI_RIGHT_PANEL : BlokiPanel
var UI_LEFT_PANEL_PARENT : BlokiPanelParent
var UI_RIGHT_PANEL_PARENT : BlokiPanelParent
var UI_BOTTOM_PANEL : BlokiPanel
var UI_BOTTOM_LEFT_PANEL : BlokiPanel
var UI_BOTTOM_RIGHT_PANEL : BlokiPanel
## VIEWPORT
var UI_VIEWPORT_WINDOW : MainViewportWidow
var UI_TOOL_MENU : BlokiToolMenu
var UI_MAIN_LAYOUT : BlokiMainLayout

## TABS
var UI_TABS : TabsPanel

## OPTIONS
var UI_OPTIONS : Options
## ADD PANEL
var UI_ADD_PANEL : add_panel

## SHARED NODES BETWEEN PLUGINS
var UI_VIEWPORT : Control

signal UNDO_REDO_CHANGE()
var CURRENT_UNDO_REDO : UndoRedo:
	set(new):
		CURRENT_UNDO_REDO = new
		UNDO_REDO_CHANGE.emit()
