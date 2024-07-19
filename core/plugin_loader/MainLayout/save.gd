extends Button

func _pressed():
	if not Projects.is_project_open: return
	$"../../../../../save_ask_popup".popup_centered()
	pass

func save():
	await get_tree().process_frame
	Projects.save_project()
	await get_tree().process_frame
	$"../../../../../savedpopup".popup_centered()
	Projects.refresh_projects.emit()
	pass

func _ready():
	ApiNodes.Plugins.on_selecting.connect(func(p_name):
		disabled = (p_name == "project")
		)

func _on_save_ask_popup_confirmed():
	save()
	pass
