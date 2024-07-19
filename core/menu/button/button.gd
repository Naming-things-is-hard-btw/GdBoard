extends PanelContainer


func _setup(label ,buttontext, function, icon):
	$vector/Panel/Control/c/ScrollContainer/name.text = label
	$vector/PanelContainer/VBoxContainer/c/Button.text = buttontext
	$vector/Panel/Control/c/icon.icon = icon
	$vector/PanelContainer/VBoxContainer/c/Button.pressed.connect(function)
	pass
