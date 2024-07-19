extends AnimationPlayer

func _ready() -> void:
	if not ApiNodes.Plugins: return
	ApiNodes.Plugins.on_selecting.connect(anim)
	pass

func anim(_a):
	stop()
	play("open")
