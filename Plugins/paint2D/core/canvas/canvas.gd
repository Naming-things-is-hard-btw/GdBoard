class_name DrawingCanvas extends SubViewportContainer
var plugin : BlokiPlugin:
	set(new):
		plugin = new
		frame.plugin = plugin

@onready var frame : DrawingFrame = $SubViewport/origin/frame

func _ready() -> void:
	await get_tree().process_frame
	(plugin as Paint2D).open.connect(func():
		reset()
		)
	pass

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
