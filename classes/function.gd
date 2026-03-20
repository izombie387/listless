class_name Function

enum Type {HIGHER_ORDER, LOWER_ORDER}
enum Operation {MUTATE, SELECT, ACCUM, BOOL}
var can_mutate_value: = bool()
var name: = String()
var f: = Callable()
var type: Type
var operation: Operation
var accepts_operations: = []


func info():
	return "\n".join([str(
		Type.find_key(type),
		name,
	)])


func _init(
		_name: String, 
		f_type: Type, 
		_f: Callable, 
		_operation: Operation,
		_accepts_operations: = []) -> void:
	name = _name
	type = f_type
	f = _f
	operation = _operation
	accepts_operations = _accepts_operations
	

func can_drop_to(to_element: Element) -> bool:
	match type:
		Type.HIGHER_ORDER:
			return false
		Type.LOWER_ORDER:
			match to_element.type:
				Element.Type.NUMBER: return true
				Element.Type.FUNCTION:
					match to_element.function.type:
						Type.HIGHER_ORDER: 
							return operation in to_element.function.accepts_operations
	return false
