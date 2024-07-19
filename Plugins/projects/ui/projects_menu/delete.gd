extends Button


func _pressed() -> void:
	$"../../../../delete project".popup_centered()
	pass

func _on_delete_confirmed() -> void:
	var project = $"../../../projects/ScrollContainer/MarginContainer/selection_manager".selected
	if not project: return
	var _name = (project as BlokiProject).project_name
	var path = ProjectSettings.globalize_path(Projects.projects_path + _name)
	OS.move_to_trash(path)
	Projects.refresh_projects.emit()
	pass

func _ready() -> void:
	disabled = true
	$"../../../../delete project".confirmed.connect(_on_delete_confirmed)
	$"../../../projects/ScrollContainer/MarginContainer/selection_manager".on_project_select.connect(func(proj, p_name):
		disabled = false
		)
	$"../../../projects/ScrollContainer/MarginContainer/selection_manager".on_project_unselect.connect(func():
		disabled = true
		)
	pass
