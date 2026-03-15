extends Node2D

var dragging_enemy = null
var enemy_scene = load("res://enemy/enemy.tscn")
var enemies = []

func _ready() -> void:
	var iter = 10
	enemies.resize(iter)
	for i in iter:
		var pos = Vector2(randf() * 200, randf() * 200)
		var new_enemy = spawn_enemy_at(pos)
		enemies[i] = new_enemy
		new_enemy.set_number(randi_range(1,10))

func spawn_enemy_at(pos) -> Enemy:
	var new_enemy = enemy_scene.instantiate()
	add_child(new_enemy)
	new_enemy.position = pos
	new_enemy.clicked.connect(on_enemy_clicked)
	new_enemy.released.connect(on_enemy_released)
	return new_enemy


func on_enemy_clicked(enemy):
	dragging_enemy = enemy
	dragging_enemy.z_index = 100
	
	
func on_enemy_released(_enemy):
	if dragging_enemy:
		dragging_enemy.z_index = 0
		dragging_enemy = null
	
	
func _process(_delta: float) -> void:
	if dragging_enemy:
		dragging_enemy.position = get_local_mouse_position()
