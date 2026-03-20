class_name Data

static var functions: = {
	"(+1)": Function.new(
			"(+1)", Function.Type.LOWER_ORDER,
			(func(e): return e+1), Function.Operation.MUTATE),
	"(-1)": Function.new(
			"(-1)", Function.Type.LOWER_ORDER,
			(func(e): return e-1), Function.Operation.MUTATE),
	"(*2)": Function.new(
			"(*2)", Function.Type.LOWER_ORDER,
			(func(e): return e*2), Function.Operation.MUTATE),
	"(+r)": Function.new(
			"(+r)", Function.Type.LOWER_ORDER,
			(func(e): return e+Lesson.accum), Function.Operation.MUTATE),
	"(*r)": Function.new(
			"(*r)", Function.Type.LOWER_ORDER,
			(func(e): return e*Lesson.accum), Function.Operation.MUTATE),
	"isEven": Function.new(
			"isEven", Function.Type.LOWER_ORDER,
			(func(e): print("isEven", e); return int(e%2==0)), 
			Function.Operation.BOOL),
	"isOdd": Function.new(
			"isOdd", Function.Type.LOWER_ORDER,
			(func(e): return int(e%2!=0)), 
			Function.Operation.BOOL),
	"map": Function.new(
			"map", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.map(f)), Function.Operation.MUTATE,
			[Function.Operation.MUTATE]),
	"filter": Function.new(
			"filter", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.filter(
					(func(e): return bool(f.call(e)))
			)), Function.Operation.SELECT,
			[Function.Operation.BOOL]),
	"fold+": Function.new(
			"fold+", Function.Type.HIGHER_ORDER,
			(func(arr, f): return arr.reduce(
				(func(acc, c): return acc + int(f.call(c))), 0)),
				Function.Operation.ACCUM,
			[Function.Operation.ACCUM, Function.Operation.BOOL])
}

static func return_false(..._varargs): return false
static func return_true (..._varargs): return true

#data["name"], data["rules"], data["win_condition"],
#data["can_drop_numbers"], data["functions"],
#data["display"]

static func get_function(name) -> Function:
	var function = functions.get(name)
	assert(function, "no func by that name")
	return function

static var lesson_data: = {
## BEGGINER LEVELS - Teaching higher-order concepts with lower-order functions
	"plus_one": {
		"name": "plus_one",
		"rules":
"""Drag (+1) to a number to increase its value.""",
		"target_array":
(func(): return Lesson.array.map(func(e): return e+1)),
		"win_condition":
(func(): 
	return Lesson.array == Lesson.initial_array.map(func(e): return e+1)),
		"can_drop_numbers": return_false,
		"functions": ["(+1)"].map(get_function),
	},
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
		"functions": ["(+1)", "(-1)", "map"].map(get_function),
	},
	
## FOLD
	"fold":{
		"name": "fold",
		"rules":
"""Drag a function on a number to get it's value (Odd = 0, Even = 1)
displayed in 'Result' (seperate counter from the list).
Drag a function onto fold+ to apply
the function to each array element adding each to result.
Goal: get 'Result' to 4""",
		"win_condition": (func(): return Lesson.accum == 4),
		"can_drop_numbers": return_false,
		"display": "Result",
		"functions": ["isEven", "isOdd", "(+1)", "fold+"].map(get_function)
	},
# VARIABLES
	"variables":{
		"name": "variables",
		"rules":
"""Similar to (+1) and (*2), we have (+r) and (*r) where r is
the current value in the 'Result' accumulator. Goal: all numbers
in the array at least 100.
Hint: Use fold+ to get the 'Result' value up high enough to be fast.""",
		"win_condition":
(func(): return Lesson.array.all(func(e): return e>=100)),
		"can_drop_numbers": return_false,
		"display": "Result",
		"functions": ["isEven", "isOdd", "(+1)", "(+r)", "(*r)", "fold+",].map(get_function),
	},
## FILTER
	"filter":{
		"name": "filter",
		"rules":
"""Drag a function on a number to add it's value to the result. 
(True=1 or False=0). Drag a function onto filter to select
only the numbers that are true for that function
Goal: select all elements""",
		"win_condition":
(func(): return Lesson.selected == Lesson.array),
		"can_drop_numbers": return_false,
		"display": "Result",
		"functions": ["isEven", "isOdd", "(+1)", "filter"].map(get_function),
	},

## SANDBOX
	"sandbox":{
		"name": "sandbox",
		"rules":
"""Goal: [0,0,0,0], all selected,
and result == 1""",
		"win_condition": 
(func(): return (Lesson.accum == 1 and Lesson.selected == [0,0,0,0])),
		"can_drop_numbers": return_true,
		"display": "Result",
		"functions": functions.values() # all of them
	},
	
}
