extends Label


func _get_drag_data(_at_position: Vector2) -> Variant:
	var obj = $"../../../../../..".B_object
	var varname = $"../../../../../..".variable_name
	var lab = preload("res://core/components/ui_components/drag/drag.tscn").instantiate()
	lab.text = text
	lab.icon = $"../../icon".icon
	set_drag_preview(lab)
	return {"name": varname, "obj": obj}
