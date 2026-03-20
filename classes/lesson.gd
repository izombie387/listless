class_name Lesson

static var name: = String()
static var rules: = String()
static var array: = Array()
static var initial_array: = Array()
static var target_array: = Array()
static var accum: Variant = 0
static var selected: Array = Array()
static var _win_condition: = Callable()
static var _can_drop_numbers_call: = Callable()
static var _functions: = Array()
const LENGTH = 4


static func _static_init() -> void:
	randomize_array()
	
	
static func load_lesson_by_name(lesson_name: String) -> Dictionary:
	var data = Data.lesson_data.get(lesson_name)
	if not data: print("invalid lesson name"); return {}
	accum = 0
	selected = []
	randomize_array()
	if data["win_condition"].call() == true: # while loop if im careful
		randomize_array()
	return _load_lesson(
		data["name"], 
		data["rules"], 
		data["win_condition"],
		data["target_array"].call() if "target_array" in data else [],
		data["can_drop_numbers"],
		data["functions"],
	)
	
static func _load_lesson(
		_name: String,
		_rules: String,
		win_condition: Callable,
		_target_array: Array,
		can_drop_numbers_call: Callable,
		functions: Array) -> Dictionary:
	name = _name
	rules = _rules
	_win_condition = win_condition
	target_array = _target_array
	_can_drop_numbers_call = can_drop_numbers_call
	_functions = functions
	prints("Current test:", name)
	return {
		"rules": rules,
		"functions": functions,
		"target_array": target_array,
	}
	

static func can_drop_numbers(from: Element, to: Element):
	return _can_drop_numbers_call.call(from, to)


static func is_won() -> bool:
	return _win_condition.call()


static func is_sorted():
	for i in array.size() - 1:
		if array[i] > array[i+1]:
			return false
	return true


static func get_functions():
	return _functions


static func randomize_array():
	array.resize(LENGTH) # incase we mutated/filtered the length
	for i in LENGTH:
		array[i] = randi_range(0,9)
	initial_array = array.duplicate()
	return array
	
		
static func drop_data(from: Element, to: Element):
	prints("drop data:", from.info(), to.info())
	match from.type:
		Element.Type.NUMBER:
			match to.type:
				Element.Type.NUMBER:
					_swap(from.index, to.index)
		Element.Type.FUNCTION:
			match to.type:
				Element.Type.NUMBER:
					call_lower(from.function, to.index)
				Element.Type.FUNCTION:
					match from.function.type:
						Function.Type.LOWER_ORDER:
							match to.function.type:
								Function.Type.HIGHER_ORDER:
									call_higher(from.function, to.function)
		_: prints("no match at drop data:", from.info(), to.info())
							
							
static func call_lower(from: Function, to_idx: int):
	match from.operation:
		Function.Operation.MUTATE:
			array[to_idx] = from.f.call(array[to_idx])
		Function.Operation.SELECT:
			selected = from.f.call(array[to_idx])
		Function.Operation.BOOL:
			# NB now just sets rather than adds to accum
			accum = from.f.call(array[to_idx])
		_:
			print("no operaton type match for call_lower")


static func call_higher(from: Function, to: Function):
	match to.operation:
		Function.Operation.MUTATE:
			array = to.f.call(array, from.f)
		Function.Operation.SELECT:
			selected = to.f.call(array, from.f)
		Function.Operation.ACCUM:
			# NB setting not adding now
			accum = to.f.call(array, from.f)
	
	
static func _swap(from_idx, to_idx):
	var from = array[from_idx]
	var to   = array[to_idx]
	array[from_idx] = to
	array[to_idx]   = from
	

static func get_min_moves_bubble_sort():
	var arr = array.duplicate()
	var sorted = arr.duplicate()
	sorted.sort()
	var steps = 0
	while arr != sorted:
		for i in arr.size()-1:
			if arr[i] > arr[i+1]:
				var temp = arr[i+1]
				arr[i+1] = arr[i]
				arr[i] = temp
				steps += 1
	return steps
	
	
