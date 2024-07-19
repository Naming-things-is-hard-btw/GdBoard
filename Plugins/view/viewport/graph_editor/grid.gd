extends Sprite2D

func _process(_delta: float) -> void:
	region_rect.size = (get_viewport_rect().size) / ($"..".zoom)
	region_rect.position = ($"..".position/scale) - (region_rect.size/2.0)
	pass

func _ready() -> void:
	visible = ApiMem.show_grid
	ApiMem.showgrid_update.connect(func():
		visible = ApiMem.show_grid
		)
