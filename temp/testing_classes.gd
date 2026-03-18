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
@export var display: Label
@onready var tree: = get_tree()
var element_scene = load("res://prototype/element.tscn")
var elements: Array[Element] = []
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
			update_ui()
			},
	next_lesson_button: {
		"action": func(): current_lesson_index += 1,
	},
}
var current_lesson_index: = 0 :
	set(v):
		current_lesson_index = clamp(v, 0, lesson_names.size())
		on_lesson_selected(current_lesson_index)
var lesson_names: = []
		
		
		
func _ready() -> void:
	next_lesson_button.disabled = true
	lessons_menu.clear()
	lessons_menu.item_selected.connect(on_lesson_selected)
	for lesson_name in Data.lesson_data.keys():
		lesson_names.append(lesson_name)
		lessons_menu.add_item(lesson_name.capitalize())
	for button in buttons:
		button.pressed.connect(on_button_clicked.bind(button))
	for i in Lesson.LENGTH:
		add_number(i)
	current_lesson_index = 0 # load first lesson
	
	
func on_lesson_selected(lesson_index):
	var ui_data = Lesson.load_lesson_by_name(lesson_names[lesson_index])
	rules.text = ui_data["rules"]
	functions.get_children().map(func(c): c.queue_free())
	var new_funcs = ui_data["functions"]
	if new_funcs:
		for f in new_funcs:
			assert(f, str("non existant func name"))
			add_function(f)
	moves = 0
	update_ui()


func update_ui():
	for i in Lesson.LENGTH:
		elements[i].update_value(Lesson.array[i])
	prints("Selected:", Lesson.selected)
	for value in Lesson.selected:
		for i in elements.size():
			if Lesson.array[i] == value:
				elements[i].select(true)
				continue
			else:
				elements[i].select(false)
	display.text = (str("Result: ", Lesson.accum))
	check_win_condition()


func check_win_condition():
	if Lesson.is_won():
		next_lesson_button.disabled = false
		print("Won!")
	else:
		next_lesson_button.disabled = true
		
		
func add_function(f: Function) -> Node:
	var new_element = element_scene.instantiate()
	new_element.update_text(f.name)
	new_element.type = Element.Type.FUNCTION
	new_element.function = f
	new_element.dropped_on.connect(on_dropped_on)
	functions.add_child(new_element)
	elements.append(new_element)
	return new_element
	
		
func add_number(index: int):
	var new_element = element_scene.instantiate()
	new_element.index = index
	new_element.type = Element.Type.NUMBER
	new_element.dropped_on.connect(on_dropped_on)
	elements.append(new_element)
	grid.add_child(new_element)
	
func on_button_clicked(button):
	buttons[button]["action"].call()
	
	
func on_dropped_on(from, to):
	update_ui()
