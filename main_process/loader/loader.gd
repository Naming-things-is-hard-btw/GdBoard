extends Control

var scene
func _ready():
	$Loader/AnimationPlayer.play("start")
	await get_tree().create_timer(1).timeout
	var _scene : PackedScene = ResourceLoader.load("res://main_process/main.tscn")
	scene = _scene.instantiate()
	get_tree().root.add_child(scene)
	scene._hide()
	scene.update_plugins()
	scene.plugins_loaded.connect(func():
		$Loader/AnimationPlayer.play("stop")
		await get_tree().create_timer(1).timeout
		queue_free()
		scene._show()
		)
	pass

func _process(_delta: float) -> void:
	if is_instance_valid(scene):
		$Loader/Control/ProgressBar.value = scene.progress
	pass
