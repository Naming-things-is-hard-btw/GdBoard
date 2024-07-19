extends Control
class_name Options
var Menu : menu
func _ready():
	Menu = $BoxContainer/ScrollContainer/menu
	ApiNodes.UI_OPTIONS = self
	ApiNodes.Plugins.on_selecting.connect(func(_a):
		hide()
		)
	pass
