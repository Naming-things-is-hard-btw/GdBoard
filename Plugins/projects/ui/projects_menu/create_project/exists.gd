extends Label


func _ready():
	$"../../LineEdit".connect("text_changed", Callable(self, "_in"))
	$"../../../../../../down_toolbar/HBoxContainer/new".connect("button_down", Callable(self, "_a"))
	$"../../../../../..".connect("visibility_changed", Callable(self, "_a"))
	pass

func _in(_str):
	_a()
func _a():
	var txt = $"../../LineEdit".text
	visible = DirAccess.dir_exists_absolute(Projects.projects_path + txt)
	pass
