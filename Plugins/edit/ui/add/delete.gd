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
	$ConfirmationDialog.popup()

func remove():
	owner.custom_data.array.remove_at(idx-owner.loader.array.size())
	owner.save()
	owner.update()
	pass
