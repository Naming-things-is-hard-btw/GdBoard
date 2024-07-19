extends BlokiPlugin

var moved = false
var start_pos : Vector2
var current_pos : Vector2
var index : int
func _init() -> void:
	name = "select"
func on_spawn():
	Api.forward_input.connect(func(event):
		if not is_enabled(): return
		if event is InputEventScreenDrag:
			current_pos = event.position
			if not moved:
				moved = (current_pos - start_pos).length() >= 5
		if event is InputEventScreenTouch:
			if event.is_pressed():
				moved = false
				index = event.index
				start_pos = event.position
				pass
			if event.is_released():
				if moved: return
				if event.index != index: return
				var coll = ApiNodes.TouchCamera2D.select_node(event.position)
				if coll is BlokiNode: Api.select_node(coll)
				else: Api.select_node(null)
			pass
		)
