extends MarginContainer

@onready var tree = get_tree()
@export var grid: GridContainer
@export var reset: Button

@onready var buttons = {
	reset: {
		"action": func(): tree.reload_current_scene(),
	},
}


func _ready() -> void:
	for button in buttons:
		button.pressed.connect(on_button_clicked.bind(button))
		
		
func on_button_clicked(button):
	buttons[button]["action"].call()
