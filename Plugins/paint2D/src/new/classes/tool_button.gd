class_name  toolbutton
extends Button

func _ready():
	mouse_entered.connect(big)
	mouse_exited.connect(smol)
	text = str(get_index())

func big():
	create_tween().tween_property(self, "scale", Vector2(1.1,1.1), 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	pass

func smol():
	create_tween().tween_property(self, "scale", Vector2(1,1), 0.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	pass

func _pressed():
	get_tree().get_nodes_in_group("Paint2d_Tools")[0].changeTool(get_index())
	pass
