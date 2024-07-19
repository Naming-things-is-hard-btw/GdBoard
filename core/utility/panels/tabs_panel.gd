extends HBoxContainer
class_name TabsPanel

@export var selectionpanel : Panel
@export var scroll : ScrollContainer

func _init():
	ApiNodes.UI_TABS = self
	pass

func clear_buttons():
	for a in get_children():
		a.queue_free()
	pass

var tween0
var tween1
#var tween3

var last_button : Button

func press(button):
	await get_tree().process_frame
	var b = button as Button
	scroll.ensure_control_visible(b)
	if b.get_meta("project_owned"):
		if not Projects.is_project_open: return
	last_button = b
	if tween0:
		tween0.kill()
		tween0 = null
	if tween1:
		tween1.kill()
		tween1 = null
	tween0 = create_tween()
	tween1 = create_tween()
	tween0.tween_property(selectionpanel, "position", b.position ,0.4 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(Tween.EASE_OUT)
	tween1.tween_property(selectionpanel, "size", b.size , 0.4 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(Tween.EASE_OUT)
	pass

func add_button(icon : Texture2D, text : String = "") -> Button:
	var button = Button.new()
	button.text = text
	button.icon = icon
	button.flat = true
	add_child(button, true)
	button.mouse_filter = Control.MOUSE_FILTER_PASS
	if get_child_count() <= 1:
		selectionpanel.global_position = button.global_position
		selectionpanel.size = button.size
	return button

func _ready():
	ApiNodes.Plugins.on_selecting.connect(func(p_name):
		for a in get_children():
			if a.get_meta("owner_plugin").name.find(p_name) == 0:
				press(a)
		)
	child_entered_tree.connect(func():
		var p_name = ApiNodes.Plugins.selected_plugin
		for a in get_children():
			if a.get_meta("owner_plugin").name.find(p_name) == 0:
				press(a)
		)
	child_exiting_tree.connect(func():
		var p_name = ApiNodes.Plugins.selected_plugin
		for a in get_children():
			if a.get_meta("owner_plugin").name.find(p_name) == 0:
				press(a)
		)
	pass
