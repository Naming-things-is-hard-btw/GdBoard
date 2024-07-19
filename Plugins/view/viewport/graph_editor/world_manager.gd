class_name WorldManager extends Node2D

func _init() -> void:
	ApiNodes.WORLD_MANAGER = self

var current_world_name : String

func set_current_world(root_name):
	var root = get_node(NodePath(root_name))
	if is_instance_valid(root):
		ApiNodes.CURRENT_TREE_ROOT = root
		current_world_name = root_name
		Api.update_world.emit()
	pass

func load_world(packed_scene : PackedScene, world_name):
	var root = Node2D.new()
	var scene = packed_scene
	if scene != null:
		scene = scene.instantiate()
		if scene != null:
			for a in scene.get_children():
				scene.remove_child(a)
				a.owner = null
				root.add_child(a, true)
				a.owner = root
	root.name = world_name
	add_child(root, true)
	set_current_world(world_name)
	pass

func close_world(root_name):
	var root = get_node(NodePath(root_name))
	if is_instance_valid(root):
		ApiNodes.CURRENT_TREE_ROOT = get_child(clamp(root.get_index()-1, 0, root.get_index()))
		root.get_parent().remove_child(root)
		root.queue_free()
		current_world_name = ApiNodes.CURRENT_TREE_ROOT.name
		Api.update_world.emit()
	pass

func save_world(root_name) -> PackedScene:
	
	
	return null

func close_all():
	for a in get_children():
		close_world(a.name)
	pass
