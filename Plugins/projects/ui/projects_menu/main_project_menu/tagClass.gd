class_name TagClass
extends Button

signal selected(tabname)

func _pressed():
	selected.emit(text)

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	flat = true
