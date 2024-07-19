class_name DrawingImage extends TextureRect

@export var old_image : TextureRect
@export var preview : TextureRect
@export var final_image_vp : SubViewport
@export var draw_preview_vp : SubViewport
@export var root : Node2D

@export var width : int = 700
@export var height : int = 500
@export var color : Color = Color.WHITE
@export var candraw = true:
	set(new):
		candraw = new
		if not candraw: mouse_filter = Control.MOUSE_FILTER_IGNORE
		if candraw:
			if get_tree().get_nodes_in_group("Paint2d_Tools")[0].use_mouse(): mouse_filter = Control.MOUSE_FILTER_PASS
			else: mouse_filter = Control.MOUSE_FILTER_IGNORE
var use_mouse = false:
	set(new):
		if use_mouse != new:
			if get_tree().get_nodes_in_group("Paint2d_Tools")[0].use_mouse(): mouse_filter = Control.MOUSE_FILTER_PASS
			else: mouse_filter = Control.MOUSE_FILTER_IGNORE
		use_mouse = new
		pass

func iload(image : Image):
	texture = ImageTexture.create_from_image(image)
	width = texture.get_image().get_size().x
	height = texture.get_image().get_size().y
	final_image_vp.size = texture.get_image().get_size()
	draw_preview_vp.size = texture.get_image().get_size()
	pass

func isave() -> Image:
	return texture.get_image()

func inew(customwidth = width, customheight = height, customcolor : Color = color):
	var image = Image.create(customwidth, customheight, false, Image.FORMAT_RGBA8)
	image.fill(customcolor)
	iload(image)
	pass


func _ready():
	final_image_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	draw_preview_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	inew()

func _process(_delta):
	use_mouse = get_tree().get_nodes_in_group("Paint2d_Tools")[0].use_mouse()

func _input(event):
	if event is InputEventScreenTouch:
		if event.index >= 1:
			_canceldrawing()
	if event is InputEventScreenDrag:
		if event.index >= 1:
			_canceldrawing()
	pass

var is_drawing = false
func _gui_input(event):
	if not candraw: return
	if event is InputEventScreenTouch:
		if event.index == 0:
			if event.pressed:
				_startdrawing(event)
			else:
				_stopdrawing(event)
	if event is InputEventScreenDrag:
		if event.index == 0:
			_updatedrawing(event)
			if is_drawing:
				accept_event()
		pass
	if not is_drawing: return
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].canvas_input.emit(event)
	pass





var imagesize
func _startdrawing(event):
	final_image_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	draw_preview_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	old_image.texture = texture
	texture = final_image_vp.get_texture()
	imagesize = (Vector2)(texture.get_image().get_size())
	var position_normalized = event.position / size
	var final_position = position_normalized * imagesize
	final_position.x = floor(final_position.x) + 0.5
	final_position.y = floor(final_position.y) + 0.5
	is_drawing = true
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].start(final_position, root, old_image, preview)
	await get_tree().process_frame
	await get_tree().process_frame
	preview.texture = draw_preview_vp.get_texture()
	pass

func _stopdrawing(_event):
	if not is_drawing: return
	final_image_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	draw_preview_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	var newimage = final_image_vp.get_texture().get_image()
	var oldimage = old_image.texture.get_image()
	old_image.position = Vector2(0,0)
	old_image.size = old_image.get_parent().size
	old_image.rotation = 0
	preview.position = Vector2(0,0)
	preview.size = preview.get_parent().size
	preview.rotation = 0
	old_image.pivot_offset = old_image.get_parent().size/2.0
	preview.pivot_offset = preview.get_parent().size/2.0
	old_image.texture = null
	preview.texture = null
	var undoredo = ApiNodes.CURRENT_UNDO_REDO
	undoredo.create_action("draw")
	undoredo.add_do_property(self, "texture", ImageTexture.create_from_image(newimage))
	undoredo.add_undo_property(self, "texture", ImageTexture.create_from_image(oldimage))
	undoredo.commit_action()
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].stop()
	is_drawing = false
	pass

func _updatedrawing(event):
	if not is_drawing : return
	var position_normalized = event.position / size
	var final_position : Vector2 = position_normalized * imagesize
	final_position.x = floor(final_position.x) + 0.5
	final_position.y = floor(final_position.y) + 0.5
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].update(final_position)
	pass

func _canceldrawing():
	if not is_drawing : return
	if not get_tree().get_nodes_in_group("Paint2d_Tools")[0].is_allowed_to_cancel: return
	final_image_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	draw_preview_vp.render_target_update_mode = SubViewport.UPDATE_DISABLED
	texture = old_image.texture
	old_image.position = Vector2(0,0)
	old_image.size = old_image.get_parent().size
	preview.position = Vector2(0,0)
	preview.size = preview.get_parent().size
	old_image.texture = null
	preview.texture = null
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].cancel()
	is_drawing = false
	pass
