extends PanelContainer
class_name Element
enum Type {NUMBER, FUNCTION, DISPLAY}
signal dropped_on(from_element, to_element)
@export var label: Label
var index = -1
var type: Type
var function: Function = null


func info():
	return "\n".join([str(
		Type.find_key(type),
		function.info() if function else "",
	)])

func select(on: bool):
	if on:
		theme_type_variation = &"SelectedPanelContainer"
	else:
		theme_type_variation = &""


func _drop_data(_at_position: Vector2, incoming_element: Variant) -> void:
	Lesson.drop_data(incoming_element, self)
	dropped_on.emit(incoming_element, self)
	
	
func _can_drop_data(_at_position: Vector2, incoming_element: Variant) -> bool:
	return incoming_element.can_drop_to(self)


func update_text(text: String):
	label.text = text


func update_value(new_val: int):
	label.text = str(new_val)
	

func _get_drag_data(_at_position: Vector2) -> Variant:
	set_drag_preview(self.duplicate(true))
	return self
	
	
func can_drop_to(to_element: Element) -> bool:
	match type:
		Type.NUMBER:
			match to_element.type:
				Type.NUMBER:
					return Lesson.can_drop_numbers(self, to_element)
		Type.FUNCTION:
			return function.can_drop_to(to_element)
	return false
