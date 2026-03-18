class_name Function

enum Type {HIGHER_ORDER, LOWER_ORDER}
enum Operation {MUTATE, SELECT, ACCUM}
var can_mutate_value: = false
var name: = ""
var type: Type
var f: = Callable()
var operation: Operation


func info():
	return "\n".join([str(
		Type.find_key(type),
		name,
	)])


func _init(
		_name: String, 
		f_type: Type, 
		_f: Callable, 
		_operation: Operation) -> void:
	name = _name
	type = f_type
	f = _f
	operation = _operation
	

func can_drop_to(to_element: Element) -> bool:
	match type:
		Type.HIGHER_ORDER:
			return false
		Type.LOWER_ORDER:
			match to_element.type:
				Element.Type.NUMBER: return true
				Element.Type.FUNCTION:
					match to_element.function.type:
						Type.HIGHER_ORDER: return true
	return false
