class_name project_selection_manager extends Control

var selected : BlokiProject = null
var selected_name : String
var oldselected : BlokiProject = null
signal on_project_select(proj, _name)
signal on_project_unselect()

func unselect_all():
	for a in get_children():
		a._unselect()
	await get_tree().process_frame
	on_project_unselect.emit()
	pass

func _timeout():
	possible_doubleclick = false
	pass
signal double_click()
var clicks = 0
var possible_doubleclick = false
func set_selected(proj):
	if proj is BlokiProject: selected_name = proj.project_name
	if proj != oldselected or not possible_doubleclick: clicks = 0
	if clicks == 0: possible_doubleclick = true
	clicks += 1
	get_tree().create_timer(0.3).connect("timeout", Callable(self, "_timeout"))
	if clicks >= 2 and possible_doubleclick:
		double_click.emit()
		clicks = 0
	
	
	for a in get_children():
		a._unselect()
	selected = proj
	on_project_select.emit(proj, selected_name)
	oldselected = selected
	pass


func _on_selection_manager_double_click():
	Api.loading_show()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	Projects.close_project()
	Projects.open_project(selected)
	Api.loading_hide()
	pass
