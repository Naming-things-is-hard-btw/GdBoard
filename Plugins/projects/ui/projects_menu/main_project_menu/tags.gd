extends Control

var tags : Array
func _refresh():
	for a in $HBoxContainer.get_children():
		a.queue_free()
	tags.clear()
	for a in $"../../../projects/ScrollContainer/MarginContainer/selection_manager".get_children():
		var proj : BlokiProject = a.project
		for tag in proj.tags:
			if tags.find(tag) == -1: tags.append(tag)
			pass
		pass
	
	var all = TagClass.new()
	all.text = "All"
	all.icon = preload("res://theme/modern_icons/radio_button_checked.svg")
	$HBoxContainer.add_child(all)
	var _b = all.connect("selected", Callable(self, "_search"))
	
	for tag in tags:
		var inst = TagClass.new()
		inst.text = tag
		inst.icon = preload("res://theme/modern_icons/radio_button_unchecked.svg")
		$HBoxContainer.add_child(inst)
		var _a = inst.connect("selected", Callable(self, "_search"))
	pass

func _search(tagname):
	for a in $HBoxContainer.get_children():
		if a.text == tagname:
			a.icon = preload("res://theme/modern_icons/radio_button_checked.svg")
		else:
			a.icon = preload("res://theme/modern_icons/radio_button_unchecked.svg")
	for a in $"../../../projects/ScrollContainer/MarginContainer/selection_manager".get_children():
		var proj : BlokiProject = a.project
		a.visible = proj.tags.find(tagname) != -1
		if tagname == "All": a.visible = true
	pass
