class_name DrawingCanvas extends SubViewportContainer

func _ready() -> void:
	get_tree().get_nodes_in_group("Paint2d_Global")[0].open.connect(func():
		reset()
		)
	pass

@onready var frame : DrawingFrame = $SubViewport/origin/frame

func load_image(image : Image):
	($SubViewport/origin/frame as DrawingFrame).load_image(image)
	pass

func save_image() -> Image:
	return $SubViewport/origin/frame.save_frame()

func new_image(customwidth, customheight, customcolor):
	reset()
	$SubViewport/origin/frame.new_frame(customwidth, customheight, customcolor)

func reset():
	$SubViewport/origin/TouchCamera.zoom = $SubViewport/origin/TouchCamera.cam_zoom * 0.3
	$SubViewport/origin/TouchCamera.position = Vector2()
	pass
