extends Control

@export var rules: Label
@export var grid: HBoxContainer
@export var moves_label: Label
@export var min_moves_label: Label
@export var reset_button: Button
@export var randomize_button: Button
@export var next_lesson_button: Button
@export var functions: HBoxContainer
@export var lessons_menu: OptionButton
@onready var tree: = get_tree()

var current_lesson_index: = 0 :
	set(v):
		#current_lesson_index = clamp(v, 0, Lesson.tests.keys().size())
		on_lesson_selected(current_lesson_index)
var display: Element = null
var element_scene = load("res://prototype/element.tscn")
var moves: int = 0 :
	set(v):
		moves = v
		moves_label.text = str("Moves: ", moves)


@onready var buttons = {
	reset_button: {
		"action": func(): tree.reload_current_scene(),
	},
	randomize_button: {
		"action": func(): 
			Lesson.randomize_array()
			update_values()
			},
	next_lesson_button: {
		"action": func(): current_lesson_index += 1,
	},
}

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(on_button_clicked.bind(button))
	var array = Lesson.randomize_array()
	for i in Lesson.LENGTH:
		add_number(array[i], i)
	min_moves_label.text = str(
			"Min moves possible: ",
			Lesson.get_min_moves()
	)
	lessons_menu.item_selected.connect(on_lesson_selected)
	lessons_menu.clear()
	#for lesson_name in tests.keys():
		#lessons_menu.add_item(lesson_name.capitalize())
	on_lesson_selected(0) # first lesson: bubble sort
	
		
func on_lesson_selected(lesson_index):
	#Lesson.load_lesson(lesson_index)
	moves = 0
	functions.get_children().map(func(c): c.queue_free())
	var new_funcs = Lesson.get_functions()
	if new_funcs: 
		for f_name in new_funcs.keys():
			var details = new_funcs[f_name]
			add_function(f_name, details["type"], details["f"])
	var display_name = Lesson.get_display()
	if display_name:
		display = add_function(display_name, Element.Type.DISPLAY, Callable())
	else:
		display = null
	#rules.text = Lesson.get_rules()
	Lesson.randomize_array()
	update_values()

		
func on_dropped_on(_from_data, _to_data):
	moves += 1
	update_values()


func update_values():
	var elements = grid.get_children()
	for i in Lesson.LENGTH:
		elements[i].update_value(Lesson.array[i])
	#if display:
		#display.update_text(str("Result: ", Lesson.accum))
	check_win_condition()


func check_win_condition():
	if Lesson.is_won():
		print("Complete!")
		next_lesson_button.disabled = false
	else:
		next_lesson_button.disabled = true
		
		
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

func on_button_clicked(button):
	buttons[button]["action"].call()
