class_name Data

static var functions: = {
	"(+1)": Function.new(
			"(+1)", Function.Type.LOWER_ORDER,
			(func(e): return e+1), Function.Operation.MUTATE),
	"(-1)": Function.new(
			"(-1)", Function.Type.LOWER_ORDER,
			(func(e): return e-1), Function.Operation.MUTATE),
	"isEven": Function.new(
			"isEven", Function.Type.LOWER_ORDER,
			(func(e): return int(e%2==0)), Function.Operation.ACCUM),
	"isOdd": Function.new(
			"isOdd", Function.Type.LOWER_ORDER,
			(func(e): return int(e%2!=0)), Function.Operation.ACCUM),
	"map": Function.new(
			"map", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.map(f)), Function.Operation.MUTATE),
	"filter": Function.new(
			"filter", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.filter(
					(func(): return bool(f.call()))
			)), Function.Operation.SELECT),
	"fold+": Function.new(
			"fold+", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.reduce(
				(func(acc, c): return acc + int(f.call(c))), 0)),
				Function.Operation.ACCUM),
}

static func return_false(..._varargs): return false

#data["name"], data["rules"], data["win_condition"],
#data["can_drop_numbers"], data["min_moves"], data["functions"],
#data["display"]

static func get_function(name) -> Function:
	var function = functions.get(name)
	assert(function, "no func by that name")
	return function

static var lesson_data: = {
## BUBBLE_SORT
	"bubble_sort": {
		"name": "bubble_sort",
		"rules": 
"""Swap ajacent numbers by dragging and dropping.
Sort the from lowest to highest, left to right.""",
		"win_condition": Lesson.is_sorted,
		"can_drop_numbers":
(func(from, to):
	return abs(from.index - to.index) == 1),
		"min_moves": Lesson.get_min_moves_bubble_sort,
		"functions": [],
	},
	#"insertion_sort":{},
	#"all":{},
	#"any":{},
	#"take":{},
	#"drop":{},
	#"fmap":{},
	
## MAP
	"map":{
		"name": "map",
		"rules":
"""Drag a function on a number to change it's value.
Drag a function onto map to apply it to all elements
Goal: get an array with all 10s [10,10..] in the fewest moves""",
		"win_condition":
(func(target=10): return Lesson.array.all(func(e): return e==target)),
		"can_drop_numbers": return_false,
		"min_moves": (func(): return -1),
		"functions": ["(+1)", "(-1)", "map"].map(get_function),
	},
	
## FOLD
	"fold":{
		"name": "fold",
		"rules":
"""Drag a function on a number to get it's value. 
(Odd = 0, Even = 1). Drag a function onto fold to apply
the function to each array element adding each result
Goal: get the total to at least 10""",
		"win_condition": (func(): return Lesson.accum >= 10),
		"can_drop_numbers": return_false,
		"min_moves": (func(): return -1),
		"display": "total",
		"functions": ["isEven", "isOdd", "fold+"].map(get_function)
	},
	
## FILTER
	"filter":{
		"name": "filter",
		"rules":
"""Drag a function on a number to get it's value. 
(True or False). Drag a function onto filter to get
only the numbers that are true for that function
Goal: perform a filter that gets all of the elements at once""",
		"win_condition": 
(func(): return Lesson.accum == Lesson.array if Lesson.accum is Array else false),
		"can_drop_numbers": return_false,
		"min_moves": (func(): return -1),
		"display": "total",
		"functions": ["isEven", "isOdd", "(+1)", "filter"].map(get_function),
	},
}
