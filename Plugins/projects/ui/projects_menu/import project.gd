extends FileDialog


func _on_import(path: String) -> void:
	if path.get_extension() == "res" or path.get_extension() == "tres":
		var dat = load(path)
		if dat is Graph:
			var bpc = BlokiProjectConverter.new()
			add_child(bpc)
			await bpc.ConvertProject(dat, path.get_file().get_basename())
			bpc.queue_free()
		return
	
	if FileAccess.file_exists("user://TEMP.res"):
		DirAccess.remove_absolute("user://TEMP.res")
	DirAccess.copy_absolute(path, "user://TEMP.res")
	var dat = load("user://TEMP.res")
	if not dat is BlokiProject: return
	var project = dat.duplicate(true) as BlokiProject
	var p_path = Projects.projects_path + project.project_name
	if DirAccess.dir_exists_absolute(p_path):
		$"../project_already_exists".popup_centered()
		$"../project_already_exists".dialog_text = "project ||" + project.project_name + "|| already exists"
		return
	DirAccess.make_dir_absolute(p_path)
	ResourceSaver.save(project, (p_path + "/" + project.project_name + ".res"), ResourceSaver.FLAG_COMPRESS )
	Projects.refresh_projects.emit()
	if FileAccess.file_exists("user://TEMP.res"):
		DirAccess.remove_absolute("user://TEMP.res")
	pass
