extends Button
@export var spawner : scenespawner
var builtin = false
var idx
func _ready() -> void:
	spawner.current_node_changed.connect(func():
		builtin = not owner.current_index >= owner.loader.array.size()
		idx = owner.current_index
		
		var data : ItemGroup 
		if builtin: data = owner.loader.array[idx]
		else: data = owner.custom_data.array[idx-owner.loader.array.size()]
		button_pressed = data.is_in_favorates
		if data.built_in:
			if not (owner.custom_data as ItemGroupLoader).built_in_favorates.has(idx):
				(owner.custom_data as ItemGroupLoader).built_in_favorates[idx] = false
			button_pressed = (owner.custom_data as ItemGroupLoader).built_in_favorates[idx]
		)
	pass

func _pressed() -> void:
	var data : ItemGroup 
	if builtin: data = owner.loader.array[idx]
	else: data = owner.custom_data.array[idx-owner.loader.array.size()]
	data.is_in_favorates = button_pressed
	if data.built_in:
		(owner.custom_data as ItemGroupLoader).built_in_favorates[idx] = data.is_in_favorates
	ApiMem.favorates_update.emit()
	owner.save()
	pass
