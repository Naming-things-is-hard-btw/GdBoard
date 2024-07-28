extends Control

@export var selection_manager : project_selection_manager
@export var tags : Control


func _ready() -> void:
	Projects.refresh_projects.connect(_refresh)
	pass

func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			selection_manager.unselect_all()
			pass
		pass
	pass

func _refresh():
	$main_project_menu.show()
	$new_project.hide()
	#$main_project_menu/tags_refresh/HBoxContainer/refresh._pressed()
	pass
