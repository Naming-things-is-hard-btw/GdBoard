extends Button


func _pressed():
	owner.on_value_changed(Curve.new())
	pass
