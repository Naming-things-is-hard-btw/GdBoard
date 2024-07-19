extends Button

func _pressed() -> void:
	$"import project".popup_centered()

func _on_import(path: String) -> void:
	if FileAccess.file_exists("user://TEMP.res"):
		DirAccess.remove_absolute("user://TEMP.res")
	DirAccess.copy_absolute(path, "user://TEMP.res")
	var dat = load("user://TEMP.res")
	if not dat is ItemGroup: return
	dat = dat.duplicate(true)
	var itemgroup = dat
	itemgroup.tag = "Imported"
	owner.custom_data.array.append(itemgroup)
	owner.save()
	owner.update()
	if FileAccess.file_exists("user://TEMP.res"):
		DirAccess.remove_absolute("user://TEMP.res")
	pass
