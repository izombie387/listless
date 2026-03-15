extends Sprite2D

class_name Enemy
signal clicked(this_enemy)
signal released(this_enemy)
@export var number_label: Label
@export var area: Area2D

var number: int = -1

func _ready() -> void:
	area.input_event.connect(on_area_input)
	
	
func on_area_input(_vp, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			clicked.emit(self)
		else:
			released.emit(self)


func set_number(num: int) -> void:
	number_label.text = str(num)
	number = num
