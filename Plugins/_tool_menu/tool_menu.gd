extends BlokiPlugin

func on_spawn() -> void:
	ApiNodes.UI_TOOL_MENU.add_item("Open Project", "Project", func():
		ApiNodes.Plugins.select_plugin("project")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Save Project", "Project", func():
		if Projects.is_project_open:
			ApiNodes.UI_MAIN_LAYOUT.save()
		)
	ApiNodes.UI_TOOL_MENU.add_item("Close Project", "Project", func():
		if Projects.is_project_open:
			ApiNodes.UI_MAIN_LAYOUT.close_project()
		)
	ApiNodes.UI_TOOL_MENU.add_item("Undo", "Project", func():
		var undoredo = ApiNodes.CURRENT_UNDO_REDO
		if undoredo == null: return
		if undoredo.has_undo():
			undoredo.undo()
		)
	ApiNodes.UI_TOOL_MENU.add_item("Redo", "Project", func():
		var undoredo = ApiNodes.CURRENT_UNDO_REDO
		if undoredo == null: return
		if undoredo.has_redo():
			undoredo.redo()
		)
	ApiNodes.UI_TOOL_MENU.add_item("Project Settings", "Project", func():
		var window = preload("res://Plugins/_tool_menu/project settings/project settings window.tscn").instantiate()
		ApiNodes.UI_MAIN_LAYOUT.popup(window)
		)
	
	
	ApiNodes.UI_TOOL_MENU.add_item("Editor Settings", "Editor", func():
		var window = preload("res://Plugins/_tool_menu/editor settings/editor settings window.tscn").instantiate()
		ApiNodes.UI_MAIN_LAYOUT.popup(window)
		)
	ApiNodes.UI_TOOL_MENU.add_item("Edit Theme", "Editor", func():
		print("pressed0")
		)
	
	ApiNodes.UI_TOOL_MENU.add_item("Changelog", "Help", func():
		
		)
	ApiNodes.UI_TOOL_MENU.add_item("Report a Bug", "Help", func():
		OS.shell_open("https://github.com/Naming-things-is-hard-btw/GDBoard/issues")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Suggest a Feature", "Help", func():
		OS.shell_open("https://github.com/Naming-things-is-hard-btw/GdBoard_feature_suggestions/issues")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Contribute", "Help", func():
		OS.shell_open("https://github.com/Naming-things-is-hard-btw/GDBoard")
		)
	ApiNodes.UI_TOOL_MENU.add_item("About Gdboard", "Help", func():
		var window = preload("res://Plugins/_tool_menu/about/about window.tscn").instantiate()
		ApiNodes.UI_MAIN_LAYOUT.popup(window)
		)
	

func on_destruct():
	pass

func _init() -> void:
	name = "tool_menu"
	pass

func on_enable():
	pass 
