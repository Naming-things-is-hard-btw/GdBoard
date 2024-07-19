extends Button

@export var spawner : scenespawner
func _ready() -> void:
	spawner.current_node_changed.connect(func():
		disabled = not owner.current_index >= owner.loader.array.size()
		idx = owner.current_index
		)
	pass

var idx
func _pressed():
	$"export project".popup_centered()

func _on_export(path: String) -> void:
	var item : ItemGroup = owner.custom_data.array[idx-owner.loader.array.size()].duplicate(true)
	ResourceSaver.save(item, path + ".res", ResourceSaver.FLAG_COMPRESS)
	DirAccess.rename_absolute(path + ".res", path + ".ItemGroup")
	pass
