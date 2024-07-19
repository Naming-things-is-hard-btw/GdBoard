class_name GraphEditor extends SubViewportContainer

@export var root_node : Node2D
@export var subviewport : SubViewport
@export var touch_camera : Camera2D

var visible_intree = true
func _ready() -> void:
	ApiNodes.Plugins.on_selecting.connect(func(a):
		await get_tree().process_frame
		await get_tree().process_frame
		if is_visible_in_tree() != visible_intree:
			touch_camera.zoom = touch_camera.cam_zoom * 1.8
		visible_intree = is_visible_in_tree()
		)
