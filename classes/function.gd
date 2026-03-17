class_name Function

enum Type {NONE, HIGHER_ORDER, LOWER_ORDER}
var _name: = ""
var _f_type: = Type.NONE
var _f: = Callable()
var _can_mutate_value: = false

func _init(name: String, f_type: Type, f: Callable, can_mutate_value) -> void:
	_name = name
	_f_type = f_type
	_f = f
	_can_mutate_value = can_mutate_value

func can_drop_to_function(f_type: Type) -> bool:
	match _f_type:
		Type.NONE:
			return false
		Type.HIGHER_ORDER:
			return false
		Type.LOWER_ORDER:
			match f_type:
				Type.NONE: return false
				Type.HIGHER_ORDER: return true
				Type.LOWER_ORDER: return false
	return false

func can_drop_to_element(e_type: Element.Type) -> bool:
	match _f_type:
		Type.NONE:
			return false
		Type.HIGHER_ORDER:
			return false
		Type.LOWER_ORDER:
			match e_type:
				Element.Type.NONE: return false
				Element.Type.NUMBER: return true
				Element.Type.FUNCTION: return true
				Element.Type.DISPLAY: return false
	return false

### MAP
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
