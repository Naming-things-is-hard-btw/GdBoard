extends Button

func _process(_delta):
	if visible:
		disabled = $"../../../project_info/HBoxContainer/VBoxContainer/name/VBoxContainer/exists".visible

func _pressed():
	var p_name = $"../../../project_info/HBoxContainer/VBoxContainer/name/LineEdit".text
	var p_desc = $"../../../project_info/HBoxContainer/VBoxContainer/description/LineEdit".text
	var p_tags = $"../../../project_info/HBoxContainer/VBoxContainer/tags/LineEdit".text.split(" ")
	var project = Projects.create_project_from_template($"../../../project_info/HBoxContainer/VBoxContainer/templates/template".selected_option ,p_name, p_desc, p_tags)
	Api.loading_show()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Projects.close_project()
	Projects.open_project(project)
	Api.loading_hide()
	pass
