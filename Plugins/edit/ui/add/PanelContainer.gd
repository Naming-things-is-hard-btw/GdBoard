extends PanelContainer

func _can_drop_data(_at_position, data):
	return data is BlokiNode

func _drop_data(_at_position, data):
	if data is BlokiNode:
		var ico = data._get_info()["icon"]
		var _name = data.name
		var oldpos = data.position
		data.position = Vector2(0,0)
		var dup = data._duplicate()
		Projects.setowner(dup, dup)
		var s = PackedScene.new()
		s.pack(dup)
		var itemgroup = ItemGroup.new()
		itemgroup.item_name = _name
		itemgroup.scene = s
		itemgroup.item_icon = ico
		itemgroup.is_in_favorates = false
		itemgroup.tag = "Custom"
		owner.custom_data.array.append(itemgroup)
		owner.save()
		owner.update()
		data.position = oldpos
	pass
