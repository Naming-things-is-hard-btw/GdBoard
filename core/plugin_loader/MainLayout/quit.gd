extends Button

@export var quit_popup : ConfirmationDialog

func _pressed():
	if not Projects.is_project_open:
		get_tree().quit()
		return
	quit_popup.popup_centered()
	pass

func _ready() -> void:
	quit_popup.add_button("Close", true, "dwad")
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if Projects.is_project_open:
			quit_popup.popup_centered()
		else:
			get_tree().quit()
		pass
	pass


func _on_quit_popup_canceled() -> void:
	quit_popup.hide()
	pass

func _on_quit_popup_confirmed() -> void:
	quit_popup.hide()
	await get_tree().process_frame
	await get_tree().process_frame
	Projects.save_project()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Projects.close_project()
	pass

func _on_quit_popup_custom_action(action: StringName) -> void:
	quit_popup.hide()
	Projects.close_project()
	pass
