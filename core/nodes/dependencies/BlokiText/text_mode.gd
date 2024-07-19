extends BoxContainer

var blokitex_ref : BlokiText
func _load(tex : BlokiText):
	blokitex_ref = tex
	$OptionButton.select(blokitex_ref.h_allign)
	$OptionButton2.select(blokitex_ref.v_allign)
	$CheckButton.button_pressed = blokitex_ref.autowarp
	pass

func _on_option_button_item_selected(index: int) -> void:
	blokitex_ref.h_allign = index


func _on_option_button_2_item_selected(index: int) -> void:
	blokitex_ref.v_allign = index


func _on_check_button_toggled(toggled_on: bool) -> void:
	blokitex_ref.autowarp = toggled_on
