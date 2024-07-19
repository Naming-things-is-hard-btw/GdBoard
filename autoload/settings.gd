@tool
extends Node

var settings_data : Dictionary = {}

func _exit_tree() -> void:
	save_settings()

func _ready() -> void:
	reload_settings()
	Projects.save_proj.connect(func():
		save_settings()
		)
	pass

func reload_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.READ)
	if file == null:
		save_settings()
		file = FileAccess.open("user://settings.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	settings_data = data
	pass

func save_settings():
	var file = FileAccess.open("user://settings.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(settings_data, "\t", true, true))
	file.close()
	pass

func get_setting(path : String, default_value) -> Variant:
	if settings_data.has(path):
		return settings_data[path]
	settings_data[path] = default_value
	return default_value

func set_setting(path : String, value):
	settings_data[path] = value
