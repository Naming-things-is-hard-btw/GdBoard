extends TabContainer

func _ready() -> void:
	hide()
	size_flags_stretch_ratio = 0
	tabs_visible = false

func __HIDE():
	hide()
	pass

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
		ratio = new_size
	ratio_tween = create_tween()
	ratio_tween.tween_property(self, "size_flags_stretch_ratio", new_size, 0.5 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(0)
	if new_size == 0:
		timer = Timer.new()
		add_child(timer)
		timer.start(0.5 * (ApiMem.animation_speed)/4)
		timer.connect("timeout", Callable(self, "__HIDE"))
	pass

var ratio = 1
func _hide():
	set_panel_ratio(0)
	pass

func _show():
	set_panel_ratio(ratio)
	pass

func set_current_panel(newtab, _size : float = -1):
	for a in get_children():
		if a.get_child_count() > 0:
			var control = a.get_child(0)
			if control == newtab:
				if _size != -1:
					set_panel_ratio(_size)
				current_tab = a.get_index()
				return
	set_panel_ratio(0)
	pass

func get_current_panel():
	return get_children()[current_tab].get_child(0)

func add_panel(newtab : Control):
	var control = ScrollContainer.new()
	control.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	control.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	add_child(control)
	control.add_child(newtab, true)
	pass
