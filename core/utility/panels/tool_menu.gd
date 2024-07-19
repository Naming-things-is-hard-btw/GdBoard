class_name BlokiToolMenu extends HBoxContainer

func _init() -> void:
	ApiNodes.UI_TOOL_MENU = self

func _ready() -> void:
	clear()

func clear():
	for a in get_children():
		a.queue_free()
	pass

func set_itemroot_icon(item_root : String, icon : Texture2D):
	
	pass

func set_item_icon(item_name : String, icon : Texture2D):
	
	pass

func add_item(item_name : String, item_root : String, on_pressed : Callable):
	var popup : MenuButton = null
	for a in get_children():
		if a is MenuButton:
			if a.text == item_root:
				popup = a
				break
	if popup == null:
		popup = MenuButton.new()
		popup.text = item_root
		popup.switch_on_hover = true
		popup.get_popup().index_pressed.connect(func(index):
			var itemroot = popup.text
			_item_pressed(itemroot , index)
			)
		add_child(popup)
	popup.get_popup().add_item(item_name)
	popup.get_popup().set_item_metadata(popup.get_popup().item_count-1, on_pressed)
	pass

func _item_pressed(item_root, itemindex):
	var popup : MenuButton = null
	for a in get_children():
		if a is MenuButton:
			if a.text == item_root:
				popup = a
				break
	if popup == null: return
	var function : Callable = popup.get_popup().get_item_metadata(itemindex) as Callable
	function.call()
	pass
