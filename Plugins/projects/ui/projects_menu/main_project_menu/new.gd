extends Button

@export var new_project : Control
@export var main_project_menu : Control

func _pressed():
	main_project_menu.hide()
	new_project.show()
