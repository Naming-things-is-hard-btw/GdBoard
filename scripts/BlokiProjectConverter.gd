class_name BlokiProjectConverter extends Node


func ConvertProject(data : Graph, projectname):
	Api.console.show()
	Api.console.cclear()
	Api.console.cnprint("old project detected!!")
	await get_tree().process_frame
	Api.console.cnprint("[font s=26]Converting project using [color=86fff0]bloki_project_converter[/color][/font] type: lossy")
	Api.console.cnprint("starting in 4s...")
	await get_tree().create_timer(4).timeout
	var scene = await _convert(data)
	Api.console.cnprint("Converting project was succesful (mostly)")
	Api.console.cnprint("Loading New Project... dont forget to save once it loads ;>")
	Api.console.cnprint("starting in 4s...")
	await get_tree().create_timer(4).timeout
	var proj = Projects.create_project(projectname, "Converted Project", ["Converted"])
	Projects.setowner(scene, scene)
	var p = PackedScene.new()
	p.pack(scene)
	proj.scene = p
	proj.camera_pos = data.camera_position
	proj.camera_scale = data.camera_scale
	Projects.open_project(proj)
	await get_tree().process_frame
	Api.console.hide()

func _convert(data : Graph, p_root = null):
	var root = Node2D.new() if (p_root == null) else p_root
	for a in data.children:
		await get_tree().process_frame
		var node
		if a is GraphText:
			node = BlokiText.new()
			node.position = a.position
			node.size = a.size
			node.text = a.text
			node.text_color = a.textcolor
			node.text_size = a.textsize
			Api.console.passprint("graph_text converted to bloki_text, at transform" + str(a.position) + str(a.size))
		
		if a is GraphImage:
			node = BlokiTexture.new()
			node.position = a.position
			node.size = a.size
			node.texture = a.image.duplicate()
			Api.console.passprint("graph_image converted to bloki_texture, at transform" + str(a.position) + str(a.size))
		
		if a is GraphPanel:
			node = BlokiNodePanel.new()
			node.position = a.position
			node.size = a.size
			var st = StyleBoxFlat.new()
			st.bg_color = a.color
			node.stylebox = st
			node.corner_radius = Vector4(40,40,40,40)
			Api.console.passprint("graph_panel converted to bloki_panel, at transform" + str(a.position) + str(a.size))
		
		if a is GraphFile:
			print("unsupported!")
			Api.console.errprint("graph_files cant be converted yet!")
		
		if a is Graph:
			print("unsupported!")
			Api.console.errprint("graph_ cant be converted yet!")
		
		if a is GraphArrow:
			print("unsupported!")
			Api.console.errprint("graph_arrow cant be converted yet!")
		
		root.add_child(node, true)
		if a is Graph:
			await _convert(a, root)
	return root
