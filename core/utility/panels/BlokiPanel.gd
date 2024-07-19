extends TabContainer
class_name BlokiPanel


func _ready() -> void:
	hide()
	size_flags_stretch_ratio = 0
	tabs_visible = false

var ratio_tween : Tween
var offset_tween : Tween
var timer : Timer
func set_panel_ratio(new_size : float):
	if offset_tween:
		offset_tween.kill()
		offset_tween = null
	if ratio_tween:
		ratio_tween.kill()
		ratio_tween = null
	if timer:
		timer.stop()
		timer.queue_free()
		timer = null
	if new_size != 0:
		show()
	offset_tween = create_tween()
	###FIX
	offset_tween.tween_property(get_parent(), "split_offset", 0, 0.5 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(1)
	ratio_tween = create_tween()
	###FIX
	ratio_tween.tween_property(self, "size_flags_stretch_ratio", new_size, 0.5 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(1)
	if new_size == 0:
		ratio_tween.finished.connect(func():
			hide()
			)
	pass

func set_current_panel(newtab, _size : float = -1):
	for a in get_children():
		if a.get_child_count() > 0:
			var control = a.get_child(0)
			if control == newtab:
				if _size != -1:
					set_panel_ratio(_size)
				var index = a.get_index()
				current_tab = index
				return
	if is_instance_valid(newtab):
		add_panel(newtab)
		for a in get_children():
			if a.get_child_count() > 0:
				var control = a.get_child(0)
				if control == newtab:
					if _size != -1:
						set_panel_ratio(_size)
					var index = a.get_index()
					current_tab = index
					return
	set_panel_ratio(0)
	pass

func add_panel(newtab : Control):
	if newtab == null: return
	if is_instance_valid(newtab.get_parent()):
		newtab.get_parent().remove_child(newtab)
	var control = ScrollContainer.new()
	control.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	control.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	add_child(control)
	control.add_child(newtab, true)
	pass
