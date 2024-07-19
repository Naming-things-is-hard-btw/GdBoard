class_name GraphDataItem extends Resource


@export var position : Vector2
@export var size : Vector2 = Vector2(100,100)
@export var color : Color
@export var layer : int = 10:
	set(new):
		var old_layer = layer
		layer = clamp(new, 0, 20)
		layer_changed.emit(layer, old_layer)
		pass

signal layer_changed(new_layer, old_layer)

var _constructed_node_refrence = null
var _editor_refrence : GraphEditor = null
func _construct(_editor_ref : GraphEditor):
	return null

func create_graph_node(node : PackedScene, editor : GraphEditor):
	var n = node.instantiate()
	n.data_item_ref = self
	n.graph_editor_ref = editor
	return n
