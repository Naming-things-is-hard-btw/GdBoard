@tool
class_name BlokiArrow extends BlokiNode

var line : Line2D = Line2D.new()
var polygon : Polygon2D = Polygon2D.new()
@export var line_color : Color = Color.WHITE:
	set(new):
		line_color = new
		line.default_color = line_color
		polygon.color = line_color
@export var line_width : float = 10:
	set(new):
		line_width = new
		line.width = new
		polygon.polygon.clear()
		polygon.polygon = [
			Vector2(0,-3 * line_width),
			Vector2(10 * line_width,0),
			Vector2(0,3 * line_width),
		]



func _get_config(m : menu):
	m.add_color("Color", null, "line_color", self, Color.WHITE, func():)
	m.add_float("Width", null, "line_width", self, 10, func():)
	super._get_config(m)

func _get_info():
	return {"name": "Item", "icon": preload("res://theme/icons/drag_select.png")}

func _init():
	super._init()
	polygon.polygon.clear()
	polygon.polygon = [
		Vector2(0,-3 * line_width),
		Vector2(10 * line_width,0),
		Vector2(0,3 * line_width),
	]
	add_child(line, true, Node.INTERNAL_MODE_FRONT)
	add_child(polygon, true, Node.INTERNAL_MODE_FRONT)
	polygon.visible = false
	size = Vector2(50,50)
	copy_list.append("line_color")
	copy_list.append("line_width")
	child_entered_tree.connect(func():
		_update_arrow()
		)
	child_exiting_tree.connect(func():
		_update_arrow()
		)
	child_order_changed.connect(func():
		_update_arrow()
		)
	item_rect_changed.connect(func():
		var p = get_parent() as BlokiArrow
		if p: p._update_arrow()
		_update_arrow()
		)
	pass

func _duplicate() -> BlokiNode:
	var n = BlokiArrow.new()
	_copydata(n, true)
	for a in get_children():
		if a is BlokiNode:
			n.add_child( a._duplicate(), true )
	return n

func _update_arrow():
	if not is_instance_valid(line): return
	if not is_instance_valid(polygon): return
	line.clear_points()
	line.add_point(size/2.0)
	for a in get_children():
		if a is BlokiArrow:
			line.add_point(a.position + (a.size/2.0))
	if line.points.size() > 1:
		polygon.visible = true
		var startpoint = line.points[line.points.size()-2]
		var endpoint = line.points[line.points.size()-1]
		polygon.position = endpoint
		polygon.rotation = startpoint.direction_to(endpoint).angle()
	else:
		polygon.visible = false
	pass
