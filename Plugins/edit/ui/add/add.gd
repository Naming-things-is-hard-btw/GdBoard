extends Control
class_name add_panel

var current_index = 0
@export var scene_container : VBoxContainer
@export var scene_spawner : scenespawner
@export var delete_node : Control

var loader : ItemGroupLoader:
	set(new):
		loader = new
		ApiMem.addnode_data = new
var custom_data : ItemGroupLoader:
	set(new):
		custom_data = new
		ApiMem.custom_addnode_data = new

func update():
	for a in scene_container.get_children():
		a.queue_free()
	await get_tree().process_frame
	current_index = clamp(current_index, 0, loader.array.size()+custom_data.array.size()-2)
	if loader.array.size()+custom_data.array.size()-2 > 0:
		if current_index < loader.array.size():
			scene_spawner.set_current(loader.array[current_index])
		else: scene_spawner.set_current(custom_data.array[current_index - (loader.array.size())])
	for i in range(loader.array.size()):
		var item = loader.array[i]
		if item is ItemGroup:
			item.built_in = true
			var button = Button.new()
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			button.text = item.item_name
			button.icon = item.item_icon
			button.set_meta("scn", item)
			button.set_meta("idx", i)
			button.pressed.connect(func():
				current_index = button.get_meta("idx")
				scene_spawner.set_current(button.get_meta("scn"))
				)
			var tag = scene_container.get_node_or_null(item.tag)
			if not tag:
				tag = preload("res://Plugins/edit/ui/add/tag/tag.tscn").instantiate()
				tag.name = item.tag
				scene_container.add_child(tag, true)
				tag.add(button)
			else: tag.add(button)
	
	for i in range(custom_data.array.size()):
		var item = custom_data.array[i]
		if item is ItemGroup:
			item.built_in = false
			var button = Button.new()
			button.mouse_filter = Control.MOUSE_FILTER_PASS
			button.text = item.item_name
			button.icon = item.item_icon
			button.set_meta("scn", item)
			button.set_meta("idx", i + loader.array.size())
			button.pressed.connect(func():
				current_index = button.get_meta("idx")
				scene_spawner.set_current(button.get_meta("scn"))
				)
			var tag = scene_container.get_node_or_null(item.tag)
			if not tag:
				tag = preload("res://Plugins/edit/ui/add/tag/tag.tscn").instantiate()
				tag.name = item.tag
				scene_container.add_child(tag, true)
				tag.add(button)
			else: tag.add(button)
	pass


func save(): ResourceSaver.save(custom_data, "user://data.res", ResourceSaver.FLAG_COMPRESS)
func load_data():
	custom_data = load("user://data.res") as ItemGroupLoader
	if not custom_data:
		custom_data = preload("res://Plugins/_add_ui_scenes/default.res").duplicate()
		save()
func _init(): ApiNodes.UI_ADD_PANEL = self

func _ready():
	loader = preload("res://Plugins/_add_ui_scenes/_loader.tres")
	load_data()
	update()
	ApiNodes.Plugins.on_selecting.connect(func(_a): hide())
	visibility_changed.connect(func(): if visible: update())
	pass
