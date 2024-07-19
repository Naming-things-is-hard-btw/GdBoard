extends PanelContainer

func _ready():
	_update()
	Projects.refresh_projects.connect(_update)
	pass

func _update():
	$no_project.visible = true
	for a in $ScrollContainer/MarginContainer/selection_manager.get_children():
		a.queue_free()
	var path = Projects.projects_path
	var dir = DirAccess.open(path)
	if not dir: return
	var loading = true
	dir.list_dir_begin() # TODOConverter3To4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	while loading:
		var dirname = dir.get_next()
		if dirname == "":
			loading = false
			dir.list_dir_end()
			break
		if dir.dir_exists(dirname) and dirname != "." and dirname != "..":
			if dir.file_exists(dirname + "/" + dirname + ".res"):
				var file_path = Projects.projects_path + "/" + dirname + "/" + dirname + ".res"
				var _project = ResourceLoader.load(file_path, "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
				if _project is BlokiProject:
					$no_project.visible = false
					var inst = preload("res://Plugins/projects/ui/projects_menu/project/project.tscn").instantiate()
					$ScrollContainer/MarginContainer/selection_manager.add_child(inst)
					inst._load(_project)
				else:
					print( ResourceLoader.get_dependencies(file_path) )
			pass
		pass
	$"../tags_refresh/HBoxContainer/tags"._refresh()
	pass
