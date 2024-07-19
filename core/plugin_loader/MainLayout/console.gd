class_name BlokiConsole extends PanelContainer

func _init() -> void:
	Api.console = self
	pass

func _on_close_pressed() -> void:
	hide()

func cprint(text : String):
	$BoxContainer/Label.text += text + " "
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())

func cnprint(text : String):
	$BoxContainer/Label.text += text + "\n"
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())

func errprint(text : String):
	$BoxContainer/Label.text += "[color=ff0000] [font s=25]error[/font][/color]: " + text + "\n"
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())

func passprint(text : String):
	$BoxContainer/Label.text += "[color=c8fa00] [font s=25]pass[/font][/color]: " + text + "\n"
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())

func cclear():
	$BoxContainer/Label.text = ""
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())
	pass

func cnewline():
	$BoxContainer/Label.text += "\n"
	$BoxContainer/Label.scroll_to_line($BoxContainer/Label.get_line_count())
	pass
