extends SplitContainer
class_name BlokiPanelParent

func _ready() -> void:
	hide()
	size_flags_stretch_ratio = 0

var ratio_tween : Tween
var offset_tween : Tween
func set_panel_ratio(new_size : float):
	if offset_tween:
		offset_tween.kill()
		offset_tween = null
	if ratio_tween:
		ratio_tween.kill()
		ratio_tween = null
	if new_size != 0:
		show()
	offset_tween = create_tween()
	offset_tween.tween_property(get_parent(), "split_offset", 0, 0.5 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(1)
	ratio_tween = create_tween()
	ratio_tween.tween_property(self, "size_flags_stretch_ratio", new_size, 0.5 * (ApiMem.animation_speed) ).set_trans(ApiMem.animation_type).set_ease(1)
	if new_size == 0:
		ratio_tween.finished.connect(func():
			hide()
			)
	pass
