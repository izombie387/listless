extends Control

@export var rules: Label
@export var grid: HBoxContainer
@export var moves_label: Label
@export var min_moves_label: Label
@export var functions: HBoxContainer
@export var lessons_menu: OptionButton
@export var buttons: MarginContainer
@onready var tree: = get_tree()
const LENGTH = 8

var display: Element = null
var element_scene = load("res://prototype/element.tscn")
var moves: int = 0 :
	set(v):
		moves = v
		moves_label.text = str("Moves: ", moves)


func _ready() -> void:
	buttons.update_request.connect(update_values)
	var array = Logic.randomize_array()
	for i in Logic.LENGTH:
		add_number(array[i], i)
	min_moves_label.text = str(
			"Min moves possible: ",
			Logic.get_min_moves()
	)
	lessons_menu.item_selected.connect(on_lesson_selected)
	lessons_menu.clear()
	for lesson_name in Logic.tests.keys():
		lessons_menu.add_item(lesson_name.capitalize())
	on_lesson_selected(0) # first lesson: bubble sort
	
		
func on_lesson_selected(lesson_index):
	Logic.set_lesson(lesson_index)
	moves = 0
	functions.get_children().map(func(c): c.queue_free())
	var new_funcs = Logic.get_funcs()
	if not new_funcs: 
		return
	for f_name in new_funcs.keys():
		var details = new_funcs[f_name]
		add_function(f_name, details["type"], details["f"])
	var display_name = Logic.get_display()
	if display_name:
		display = add_function(display_name, Element.Type.DISPLAY, Callable())
	else:
		display = null
	rules.text = Logic.get_rules()
	update_values()

		
func on_dropped_on(_from_data, _to_data):
	moves += 1
	update_values()


func update_values():
	var elements = grid.get_children()
	for i in LENGTH:
		elements[i].update_value(Logic.array[i])
	if display:
		display.update_text(str(
				"Result: ", Logic.accum))
		
		
func add_function(
		f_name: String, type: Element.Type, f: Callable) -> Node:
	var new_element = element_scene.instantiate()
	new_element.update_text(f_name)
	new_element.type = type
	new_element.f = f
	new_element.dropped_on.connect(on_dropped_on)
	functions.add_child(new_element)
	return new_element

		
func add_number(value: int, index: int):
	var new_element = element_scene.instantiate()
	new_element.update_value(value)
	new_element.index = index
	new_element.type = Element.Type.NUMBER
	new_element.dropped_on.connect(on_dropped_on)
	grid.add_child(new_element)
	
	
