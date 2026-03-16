extends Node

class_name Logic

var step = 0
const LENGTH = 8
static var array: Array = [] # int
static var current_test = "bubble_sort"
static var accum: Variant = 0
static var tests = {
	"bubble_sort": {
		"rules": 
"""Swap ajacent numbers by dragging and dropping.
Sort the from lowest to highest, left to right.""",
		"can_drop":
(func(from_data, to_data):
	return abs(from_data["index"] - to_data["index"]) == 1),
		"drop_data":
			(func(from_data, to_data): 
				swap(from_data["index"], to_data["index"])),
		"min_moves": get_min_moves_bubble_sort,
		"functions": {},
	},
	#"insertion_sort":{},
	
## MAP
	"map":{
		"rules": 
"""Drag a function on a number to change it's value.
Drag a function onto map to apply it to all elements""",
		"can_drop": 
(func(from_data, _to_data):
	return from_data["type"] == Element.Type.FUNCTION),
	
		"drop_data":
(func(from_data, to_data):
	match to_data["type"]:
		Element.Type.NUMBER:
			array[to_data["index"]] =\
					from_data["f"].call(array[to_data["index"]])
		Element.Type.HIGHER_FUNC: # map
			array = array.map(from_data["f"])
),
		"min_moves": func(): return -1,
		"functions": {
			"(+1)": {
				"type": Element.Type.FUNCTION,
				"f": func(number): return number + 1,
			},
			"(-1)": {
				"type": Element.Type.FUNCTION,
				"f": func(number): return number - 1,
			},
			"map": {
				"type": Element.Type.HIGHER_FUNC,
				"f": Callable(), # empty, defined above
			},
		},
	},
	
## FOLD
	"fold":{
		"rules": 
"""Drag a function on a number to get it's value. 
(Odd = 0, Even = 1). Drag a function onto fold to apply
the function to each array element adding each result""",
		"can_drop": 
(func(from_data, _to_data):
	return from_data["type"] == Element.Type.FUNCTION),
	
		"drop_data":
(func(from_data, to_data):
	match to_data["type"]:
		Element.Type.NUMBER:
			accum = from_data["f"].call(0, array[to_data["index"]])
		Element.Type.HIGHER_FUNC: # map
			accum = array.reduce(from_data["f"], 0)
),
		"min_moves": func(): return -1,
		"display": "total",
		"functions": {
			"isEven": {
				"type": Element.Type.FUNCTION,
				"f": func(acc, c): return acc + int((c%2)==0),
			},
			"isOdd": {
				"type": Element.Type.FUNCTION,
				"f": func(acc, c): return acc + int((c%2)!=0),
			},
			"fold": {
				"type": Element.Type.HIGHER_FUNC,
				"f": Callable(), # empty, defined above
			},
		},
	},
	
## FILTER
	"filter":{
		"rules": 
"""Drag a function on a number to get it's value. 
(True or False). Drag a function onto filter to get
only the numbers that are true for that function""",
		"can_drop": 
(func(from_data, _to_data):
	return from_data["type"] == Element.Type.FUNCTION),
	
		"drop_data":
(func(from_data, to_data):
	match to_data["type"]:
		Element.Type.NUMBER:
			accum = from_data["f"].call(array[to_data["index"]])
		Element.Type.HIGHER_FUNC: # map
			accum = array.filter(from_data["f"])
),
		"min_moves": func(): return -1,
		"display": "total",
		"functions": {
			"isEven": {
				"type": Element.Type.FUNCTION,
				"f": func(c): return (c%2)==0,
			},
			"isOdd": {
				"type": Element.Type.FUNCTION,
				"f": func(c): return (c%2)!=0,
			},
			"filter": {
				"type": Element.Type.HIGHER_FUNC,
				"f": Callable(), # empty, defined above
			},
		},
	},
}

static func get_funcs():
	return tests[current_test].get("functions")

static func get_display():
	return tests[current_test].get("display")

static func set_lesson(lesson_index):
	accum = 0
	current_test = tests.keys()[lesson_index]
	print("Current test: ", current_test)


static func get_min_moves() -> int:
	return tests[current_test]["min_moves"].call()


static func get_rules() -> String:
	return tests[current_test].get("rules", "")


static func _static_init() -> void:
	array.resize(LENGTH)


static func randomize_array():
	for i in LENGTH:
		array[i] = randi_range(0,9)
	return array
		
		
static func drop_data(from_data, to_data):
	tests[current_test]["drop_data"].call(
			from_data, to_data)
		
		
static func can_drop(from_data, to_data):
	return tests[current_test]["can_drop"].call(
			from_data, to_data)

		
static func swap(from_idx, to_idx):
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
