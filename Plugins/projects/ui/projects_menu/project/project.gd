extends PanelContainer

@export var texrect : TextureRect
@export var namelabel : Label
@export var desc_label : Label
@export var tags_container : HBoxContainer
@export var prop_panel : PanelContainer


var pos
var can_press = false

func _input(event):
	if event is InputEventScreenDrag:
		if can_press and event.position.distance_to(pos) > 10:
			can_press = false
			pass
		pass

func _gui_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			pos = global_position + event.position
			can_press = true
		if not event.pressed and can_press:
			_select()
			pass

func _ready() -> void:
	pivot_offset = size / 2.0
	ApiNodes.Plugins.on_selecting.connect(func(p_name):
		if p_name == "project":
			await get_tree().process_frame
			pivot_offset = size / 2.0
			scale = Vector2(0,0)
			create_tween().tween_property(self, "scale", Vector2(1,1), 0.4).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		)
	pass

var project : BlokiProject
func _load(proj : BlokiProject):
	project = proj
	texrect.texture = ImageTexture.create_from_image(proj.icon)
	namelabel.text = proj.project_name
	desc_label.text = proj.description
	for a in proj.tags:
		var inst = Label.new()
		inst.text = a + "  "
		inst.add_theme_color_override("font_color" , Color(randf_range(0.5,1),randf_range(0.7,1),randf_range(0.2,1)))
		tags_container.add_child(inst)
	pass

func _select():
	get_parent().set_selected(project)
	$selected.show()
	pass

func _unselect():
	$selected.hide()
	pass
