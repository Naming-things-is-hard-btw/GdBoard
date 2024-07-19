class_name BrushTool
extends Node2D

## the main tool for drawing

func get_icon() -> Texture2D:
	return Texture2D.new()

func defaultblend():
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].default_blend.call()
	pass

func use_mouse() -> bool:
	return true


func start(pos : Vector2, root : Node2D, preview : TextureRect , oldimage : TextureRect):
	pass

func update(pos : Vector2):
	pass

func stop():
	pass

func cancel():
	pass
