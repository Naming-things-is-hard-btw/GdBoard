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
	ApiNodes.UI_TOOL_MENU.add_item("Project Settings", "Project", func():
		
		)
	
	ApiNodes.UI_TOOL_MENU.add_item("Editor Settings", "Editor", func():
		print("pressed1")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Edit Theme", "Editor", func():
		print("pressed0")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Report a Bug", "Help", func():
		print("pressed5")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Suggest a Feature", "Help", func():
		print("pressed1")
		)
	ApiNodes.UI_TOOL_MENU.add_item("Contribute", "Help", func():
		LinkButton
		)
	ApiNodes.UI_TOOL_MENU.add_item("About Gdboard", "Help", func():
		print("pressed1")
		)
	

func on_destruct():
	pass

func _init() -> void:
	name = "tool_menu"
	pass

func on_enable():
	pass 
