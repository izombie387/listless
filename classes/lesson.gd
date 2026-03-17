class_name Lesson

static var name: = ""
static var rules: = ""
static var _array: Array = [] # int
static var _accum: Variant = 0
static var _win_condition: = Callable()
static var _can_drop_call: = Callable()
static var _drop_data_call: = Callable()
static var _min_moves: = Callable()
static var _functions: Array[Function] = []
static var _display: = ""
const LENGTH = 4


static func _static_init() -> void:
	_array.resize(LENGTH)
	
func load_lesson(
		_name: String, 
		_rules: String,
		win_condition: Callable,
		can_drop_call: Callable,
		drop_data_call: Callable,
		min_moves: Callable,
		functions: Array[Function],
		display: String) -> void:
	name = _name
	rules = _rules
	_win_condition = win_condition
	_can_drop_call = can_drop_call
	_drop_data_call = drop_data_call
	_min_moves = min_moves
	_functions = functions
	_display = display
	
	_accum = 0
	print("Current test: ", name)

#static var tests = {
	#"bubble_sort": {
		#"rules": 
#"""Swap ajacent numbers by dragging and dropping.
#Sort the from lowest to highest, left to right.""",
		#"win_condition": is_sorted,
		#"can_drop":
#(func(from_data, to_data):
	#return abs(from_data["index"] - to_data["index"]) == 1),
		#"drop_data":
			#(func(from_data, to_data): 
				#swap(from_data["index"], to_data["index"])),
		#"min_moves": get_min_moves_bubble_sort,
		#"functions": {},
	#},
	##"insertion_sort":{},
	##"all":{},
	##"any":{},
	##"take":{},
	##"drop":{},
	##"fmap":{},
	#
### MAP
	#"map":{
		#"rules": 
#"""Drag a function on a number to change it's value.
#Drag a function onto map to apply it to all elements
#Goal: get an array with all 10s [10,10..] in the fewest moves""",
		#"win_condition":
#(func(target=10): return array.all(func(e): return e==target)),
		#"can_drop": 
#(func(from_data, _to_data):
	#return from_data["type"] == Element.Type.FUNCTION),
	#
		#"drop_data":
#(func(from_data, to_data):
	#match to_data["type"]:
		#Element.Type.NUMBER:
			#array[to_data["index"]] =\
					#from_data["f"].call(array[to_data["index"]])
		#Element.Type.HIGHER_FUNC: # map
			#array = array.map(from_data["f"])
#),
		#"min_moves": func(): return -1,
		#"functions": {
			#"(+1)": {
				#"type": Element.Type.FUNCTION,
				#"f": func(n): return n + 1,
			#},
			#"(-1)": {
				#"type": Element.Type.FUNCTION,
				#"f": func(n): return n - 1,
			#},
			#"map": {
				#"type": Element.Type.HIGHER_FUNC,
				#"f": Callable(), # empty, defined above
			#},
		#},
	#},
	#
### FOLD
	#"fold":{
		#"rules":
#"""Drag a function on a number to get it's value. 
#(Odd = 0, Even = 1). Drag a function onto fold to apply
#the function to each array element adding each result
#Goal: get the total to at least 10""",
		#"win_condition": (func(): return accum >= 10),
		#"can_drop": 
#(func(from_data, _to_data):
	#return from_data["type"] == Element.Type.FUNCTION),
	#
		#"drop_data":
#(func(from_data, to_data):
	#match to_data["type"]:
		#Element.Type.NUMBER:
			#accum += from_data["f"].call(0, array[to_data["index"]])
		#Element.Type.HIGHER_FUNC: # map
			#accum += array.reduce(from_data["f"], 0)
#),
		#"min_moves": func(): return -1,
		#"display": "total",
		#"functions": {
			#"+ifEven": {
				#"type": Element.Type.FUNCTION,
				#"f": func(acc, c): return acc + int((c%2)==0),
			#},
			#"+ifOdd": {
				#"type": Element.Type.FUNCTION,
				#"f": func(acc, c): return acc + int((c%2)!=0),
			#},
			#"fold": {
				#"type": Element.Type.HIGHER_FUNC,
				#"f": Callable(), # empty, defined above
			#},
		#},
	#},
	#
### FILTER
	#"filter":{
		#"rules":
#"""Drag a function on a number to get it's value. 
#(True or False). Drag a function onto filter to get
#only the numbers that are true for that function
#Goal: perform a filter that gets all of the elements at once""",
		#"win_condition": 
#(func(): return accum == array if accum is Array else false),
		#"can_drop":
#(func(from_data, _to_data):
	#return from_data["type"] == Element.Type.FUNCTION),
	#
		#"drop_data":
#(func(from_data, to_data):
	#match to_data["type"]:
		#Element.Type.NUMBER:
			#if from_data.has("sub_type"):
				#array[to_data["index"]] =\
						#from_data["f"].call(array[to_data["index"]])
			#else:
				#accum = from_data["f"].call(array[to_data["index"]])
		#Element.Type.HIGHER_FUNC: # map
			#accum = array.filter(from_data["f"])
#),
		#"min_moves": func(): return -1,
		#"display": "total",
		#"functions": {
			#"isEven": {
				#"type": Element.Type.FUNCTION,
				#"f": func(c): return (c%2)==0,
			#},
			#"isOdd": {
				#"type": Element.Type.FUNCTION,
				#"f": func(c): return (c%2)!=0,
			#},
			#"(+1)": {
				#"type": Element.Type.FUNCTION,
				#"sub_type": "add",
				#"f": func(c): return c+1,
			#},
			#"filter": {
				#"type": Element.Type.HIGHER_FUNC,
				#"f": Callable(), # empty, defined above
			#},
		#},
	#},
#}

static func is_won() -> bool:
	return _win_condition.call()


static func is_sorted():
	for i in _array.size() - 1:
		if _array[i] > _array[i+1]:
			return false
	return true


static func get_funcs():
	return _functions


static func get_display():
	return _display


static func get_min_moves() -> int:
	return _min_moves.call()


static func randomize_array():
	for i in LENGTH:
		_array[i] = randi_range(0,9)
	return _array
	
		
static func drop_data(from_data, to_data):
	_drop_data_call.call(from_data, to_data)
		
		
static func can_drop(from_data, to_data):
	
	#return _can_drop_call.call(from_data, to_data)

		
static func _swap(from_idx, to_idx):
	var from = _array[from_idx]
	var to   = _array[to_idx]
	_array[from_idx] = to
	_array[to_idx]   = from
	

static func get_min_moves_bubble_sort():
	var arr = _array.duplicate()
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
