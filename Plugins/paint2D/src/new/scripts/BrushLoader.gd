class_name BrushLoader extends Resource

@export var Brush_array : Array[PackedScene] = []

func load_brushes(Tools):
	for a in Brush_array:
		Tools.load_tool(a.instantiate())
		pass
	pass

