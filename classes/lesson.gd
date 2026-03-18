class_name Lesson

static var name: = ""
static var rules: = ""
static var array: Array = [] # int
static var accum: Variant = 0
static var selected: Array = []
static var _win_condition: = Callable()
static var _can_drop_numbers_call: = Callable()
static var _min_moves: = Callable()
static var _functions: Array = []
const LENGTH = 4


static func _static_init() -> void:
	array.resize(LENGTH)
	array.fill(-1)
	
	
static func load_lesson_by_name(lesson_name: String) -> Dictionary:
	var data = Data.lesson_data.get(lesson_name)
	if not data: print("invalid lesson name"); return {}
	return load_lesson(
		data["name"], data["rules"], data["win_condition"],
		data["can_drop_numbers"], data["min_moves"], data["functions"],
	)
	
static func load_lesson(
		_name: String,
		_rules: String,
		win_condition: Callable,
		can_drop_numbers_call: Callable,
		min_moves: Callable,
		functions: Array) -> Dictionary:
	name = _name
	rules = _rules
	_win_condition = win_condition
	_can_drop_numbers_call = can_drop_numbers_call
	#_drop_data_call = drop_data_call
	_min_moves = min_moves
	_functions = functions
	
	accum = 0
	randomize_array()
	print("Current test: ", name)
	return {
		"rules": rules,
		"functions": functions,
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


static func get_min_moves() -> int:
	return _min_moves.call()


static func randomize_array():
	for i in LENGTH:
		array[i] = randi_range(0,9)
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
		Function.Operation.ACCUM:
			accum += from.f.call(array[to_idx])


static func call_higher(from: Function, to: Function):
	match to.operation:
		Function.Operation.MUTATE:
			array = to.f.call(array, from.f)
		Function.Operation.SELECT:
			selected = to.f.call(array, from.f)
		Function.Operation.ACCUM:
			accum += to.f.call(array, from.f)
	
	
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
	
	
