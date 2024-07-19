extends Button

func _pressed() -> void:
	$"../../../../export project".popup_centered()
	pass

func _ready() -> void:
	disabled = true
	$"../../../projects/ScrollContainer/MarginContainer/selection_manager".on_project_select.connect(func(proj, p_name):
		disabled = false
		)
	$"../../../projects/ScrollContainer/MarginContainer/selection_manager".on_project_unselect.connect(func():
		disabled = true
		)
	pass
