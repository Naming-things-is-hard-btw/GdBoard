extends OptionButton


func _ready() -> void:
	update()
	pass

func _on_new_project_visibility_changed() -> void:
	update()
	pass

var _loader : TemplateLoader
var selected_option : BlokiProject

func update():
	var loader = load("user://templates.res") as TemplateLoader
	if loader == null:
		loader = preload("res://Plugins/_project_templates/_loader.tres").duplicate(true)
		ResourceSaver.save(loader, "user://templates.res", ResourceSaver.FLAG_COMPRESS)
	_loader = loader
	clear()
	for a in loader.array:
		if a is BlokiProject:
			add_item(a.project_name)
	select(_loader.selected)
	_on_item_selected(_loader.selected)
	pass


func _on_item_selected(index: int) -> void:
	selected_option = _loader.array[index].duplicate(true)
	_loader.selected = index
	ResourceSaver.save(_loader, "user://templates.res", ResourceSaver.FLAG_COMPRESS)
