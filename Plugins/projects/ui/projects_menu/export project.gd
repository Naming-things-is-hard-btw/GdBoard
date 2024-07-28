extends FileDialog

func _on_export(path: String) -> void:
	var oldproject : BlokiProject = owner.selection_manager.selected
	if not oldproject: return
	var new_project = oldproject.duplicate(true)
	ResourceSaver.save(new_project, path + ".res", ResourceSaver.FLAG_COMPRESS)
	DirAccess.rename_absolute(path + ".res", path + ".GDBOARD")
	pass
