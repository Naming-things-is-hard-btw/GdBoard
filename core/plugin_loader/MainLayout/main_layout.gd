class_name BlokiMainLayout extends Control

func _init() -> void:
	ApiNodes.UI_MAIN_LAYOUT = self

func popup(pop : Window):
	add_child(pop)
	pop.popup_centered()
	pass

func save():
	$save_ask_popup.popup_centered()

func close_project():
	$"quit popup".popup_centered()
