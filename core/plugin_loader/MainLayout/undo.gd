extends Button

func  _pressed():
	var undoredo = ApiNodes.CURRENT_UNDO_REDO
	if undoredo == null: return
	if undoredo.has_undo():
		undoredo.undo()

func _ready():
	ApiNodes.UNDO_REDO_CHANGE.connect(func():
		disabled = ApiNodes.CURRENT_UNDO_REDO == null
		if is_instance_valid(old_undoredo) and old_undoredo is UndoRedo:
			old_undoredo.disconnect("version_changed" , can_undo_redo)
		old_undoredo = ApiNodes.CURRENT_UNDO_REDO
		if is_instance_valid(ApiNodes.CURRENT_UNDO_REDO):
			ApiNodes.CURRENT_UNDO_REDO.version_changed.connect(can_undo_redo)
			can_undo_redo()
		)

var old_undoredo : UndoRedo
func can_undo_redo():
	if is_instance_valid(ApiNodes.CURRENT_UNDO_REDO):
		disabled = not ApiNodes.CURRENT_UNDO_REDO.has_undo()
	pass
