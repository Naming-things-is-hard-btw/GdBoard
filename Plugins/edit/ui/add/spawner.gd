class_name scenespawner extends Control

@export var root : Node2D
@export var cam : Camera2D
@export var vp : SubViewport
signal current_node_changed()

func set_current(dataitem : ItemGroup, animate : bool = true):
	if not is_instance_valid(dataitem): return
	if not dataitem is ItemGroup: return
	for a in root.get_children():
		a.queue_free()
	var inst = dataitem.scene.instantiate()
	inst.name = dataitem.item_name
	if inst is BlokiNode: inst = inst._duplicate()
	root.add_child(inst, true)
	if inst is BlokiNode:
		inst._disable_coll()
		inst.position = -inst.size/2.0
		var _size = inst.size
		var zoom = (vp.size as Vector2) / (_size as Vector2)
		cam.cam_zoom = Vector2(minf(zoom.x, zoom.y), minf(zoom.x, zoom.y)) * 0.9
	else:
		cam.cam_zoom = Vector2(0.9, 0.9)
	cam.zoom = cam.cam_zoom * 0.1
	cam.position = Vector2()
	if not animate: cam.zoom = cam.cam_zoom
	if animate: current_node_changed.emit()
	pass
