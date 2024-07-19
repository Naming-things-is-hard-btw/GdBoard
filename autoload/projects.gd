@tool
extends Node
##this is the autoload for project related operations

##emitted on openning project
signal open_proj()
##emitted on project close
signal close_proj()
signal save_proj()
##emitted on project list refresh
signal refresh_projects()

##the current project file
var current_project : BlokiProject
## true when current project is open
var is_project_open : bool = false
##path of project (for searching for projects in refresh)
var projects_path : String = "user://projects/"

func create_project(projectname : String, desc : String, tags : Array) -> BlokiProject:
	var project = BlokiProject.new()
	project.project_name = projectname
	project.description = desc
	project.tags = tags
	project.scene = PackedScene.new()
	if not DirAccess.dir_exists_absolute(Projects.projects_path):
		DirAccess.make_dir_recursive_absolute(Projects.projects_path)
	if not DirAccess.dir_exists_absolute(Projects.projects_path + projectname):
		DirAccess.make_dir_recursive_absolute(Projects.projects_path + projectname)
	ResourceSaver.save(project, Projects.projects_path + projectname + "/" + projectname + ".res", ResourceSaver.FLAG_COMPRESS)
	refresh_projects.emit()
	return ResourceLoader.load(Projects.projects_path + projectname + "/" + projectname + ".res", "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)

func create_project_from_template(template : BlokiProject, projectname : String, desc : String, tags : Array) -> BlokiProject:
	var project = template
	project.project_name = projectname
	project.description = desc
	project.tags = tags
	if not DirAccess.dir_exists_absolute(Projects.projects_path):
		DirAccess.make_dir_recursive_absolute(Projects.projects_path)
	if not DirAccess.dir_exists_absolute(Projects.projects_path + projectname):
		DirAccess.make_dir_recursive_absolute(Projects.projects_path + projectname)
	ResourceSaver.save(project, Projects.projects_path + projectname + "/" + projectname + ".res", ResourceSaver.FLAG_COMPRESS)
	refresh_projects.emit()
	return ResourceLoader.load(Projects.projects_path + projectname + "/" + projectname + ".res", "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)


func close_project():
	Api.select_node(null)
	Projects.current_project = null
	ApiNodes.WORLD_MANAGER.close_all()
	Api.update_world.emit()
	
	Api.select_node(null)
	is_project_open = false
	close_proj.emit()
	refresh_projects.emit()
	Api.clear_history.emit()
	pass

func get_project_root_path() -> String:
	return projects_path + current_project.project_name + "/"

func open_project(proj : BlokiProject):
	if not (proj is BlokiProject): return
	current_project = proj
	
	if proj.scene is not PackedScene:
		close_project()
		return
	ApiNodes.WORLD_MANAGER.load_world(proj.scene, proj.project_name)
	
	Api.update_world.emit()
	ApiNodes.TouchCamera2D.position = current_project.camera_pos
	ApiNodes.TouchCamera2D.cam_zoom = Vector2(current_project.camera_scale,current_project.camera_scale)
	await get_tree().process_frame
	Api.select_node(null)
	is_project_open = true
	open_proj.emit()
	pass

func save_project():
	if not is_project_open: return
	save_proj.emit()
	Api.select_node(null)
	await get_tree().process_frame
	var p = PackedScene.new()
	setowner(ApiNodes.CURRENT_TREE_ROOT, ApiNodes.CURRENT_TREE_ROOT)
	p.pack(ApiNodes.CURRENT_TREE_ROOT)
	current_project.scene = p
	var image : Image = get_viewport().get_texture().get_image()
	current_project.camera_pos = ApiNodes.TouchCamera2D.position
	current_project.camera_scale = ApiNodes.TouchCamera2D.cam_zoom.x
	current_project.icon = image
	ResourceSaver.save(current_project, current_project.resource_path, ResourceSaver.FLAG_COMPRESS)
	pass

func setowner(node, new_owner):
	for a in node.get_children():
		a.owner = new_owner
		setowner(a, new_owner)
	pass
