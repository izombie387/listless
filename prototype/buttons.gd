extends MarginContainer

signal update_request()
@onready var tree = get_tree()
@export var grid: GridContainer
@export var reset: Button
@export var randomize_btn: Button


@onready var buttons = {
	reset: {
		"action": func(): tree.reload_current_scene(),
	},
	randomize_btn: {
		"action": func(): 
			Logic.randomize_array()
			update_request.emit()
			}
}


func _ready() -> void:
	for button in buttons:
		button.pressed.connect(on_button_clicked.bind(button))
		
		
func on_button_clicked(button):
	buttons[button]["action"].call()
