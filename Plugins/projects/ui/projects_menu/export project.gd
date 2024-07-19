extends FileDialog

func _on_export(path: String) -> void:
	var oldproject : BlokiProject = $"../main_project_menu/projects/ScrollContainer/MarginContainer/selection_manager".selected
	if not oldproject: return
	var new_project = oldproject.duplicate(true)
	ResourceSaver.save(new_project, path + ".res", ResourceSaver.FLAG_COMPRESS)
	DirAccess.rename_absolute(path + ".res", path + ".GDBOARD")
	pass
