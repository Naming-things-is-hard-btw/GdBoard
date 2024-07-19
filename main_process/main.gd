extends Node3D

signal plugins_loaded()
var progress : float = 0.0
func update_plugins():
	ApiNodes.Plugins.clear_Plugins()
	for i in range(ApiMem.PluginArr.size()):
		var plugin = ApiMem.PluginArr[i]
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		ApiNodes.Plugins.add_plugin(load(plugin).new())
		progress = (((i+1) as float) / (ApiMem.PluginArr.size() as float)) * 100
	plugins_loaded.emit()
	pass

func _hide():
	$MainLayout.visible = false
	pass

func _show():
	$MainLayout.visible = true
	pass
