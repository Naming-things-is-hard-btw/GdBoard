extends Control


func _gui_input(event):
	$"../SubViewport".push_input(event, false)
	pass

func _input(event):
	if event is InputEventScreenTouch:
		if event.index >= 1:
			$"../SubViewport".push_input(event, true)
	pass
