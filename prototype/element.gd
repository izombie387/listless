extends PanelContainer
class_name Element
enum Type {NONE, NUMBER, FUNCTION, HIGHER_FUNC, DISPLAY}
signal dropped_on(from_idx, to_idx)
@export var label: Label
var index = -1
var type: = Type.NONE
var f: Callable


func _drop_data(_at_position: Vector2, incoming_data: Variant) -> void:
	Logic.drop_data(incoming_data, get_my_data())
	dropped_on.emit(incoming_data, get_my_data())
	
	
func _can_drop_data(_at_position: Vector2, incoming_data: Variant) -> bool:
	return Logic.can_drop(incoming_data, get_my_data())


func update_text(text: String):
	label.text = text


func update_value(new_val: int):
	label.text = str(new_val)


func _get_drag_data(_at_position: Vector2) -> Variant:
	set_drag_preview(self.duplicate(true))
	return get_my_data()


func get_my_data():
	return {
		"type": type,
		"index": index,
		"f": f,
	}
