extends Node3D


@onready var grid_map: GridMap = $GridMap
@onready var start_wave_button: Control = $StartWaveButton
@onready var on_path: Node3D = $OnPath
@onready var wave_timer: Timer = $WaveTimer

# 0: top, 1: middle, 2: bottom
var _path: Array[Array]
var _adventurers: = [
#	preload("res://Scenes/Player/adventurer_1.tscn"),
	preload("res://Scenes/Player/adventurer_2.tscn"),
	preload("res://Scenes/Player/guard_1.tscn"),
	preload("res://Scenes/Player/guard_2.tscn"),
	preload("res://Scenes/Player/mage.tscn"),
	preload("res://Scenes/Player/thief.tscn"),
]
var gold: = 1000:
	set(value):
		gold = value
		$ShopUI/Control/Label/Label.text = str(gold)
		if gold < 0:
			get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
var wave_count: = 1

@onready var tower_selector: Node3D = $TowerSelector


func _ready() -> void:
	_path = grid_map.generate()
	for i in _path.size():
		var reverse_i: = _path[i].duplicate()
		reverse_i.reverse()
		_path[i] = _path[i] + reverse_i
	
	var start_cell: Vector2i = grid_map._middle_path[3]
	start_wave_button.target = grid_map.map_to_local(Vector3(start_cell.x, 0.0, start_cell.y))
	
	start_wave_button.pressed.connect(_start_wave)
	find_child("Bow").pressed.connect(_on_bow_pressed)
	find_child("Cannon").pressed.connect(_on_cannon_pressed)
	find_child("Bat").pressed.connect(_on_bat_pressed)


func _start_wave() -> void:
	for i in 5 + sqrt(wave_count):
		var adv: Adventurer = _adventurers.pick_random().instantiate()
		adv.path = _path.pick_random().duplicate()
		on_path.add_child(adv)
		await get_tree().create_timer(2.0).timeout
	wave_count += 1
	wave_timer.start()


func _on_wave_timer_timeout() -> void:
	start_wave_button.start(10)


func _on_bow_pressed() -> void:
	var node: = preload("res://Scenes/Weapons/bow.tscn").instantiate()
	node.set_script(null)
	tower_selector.add_child(node)


func _on_cannon_pressed() -> void:
	var node: = preload("res://Scenes/Weapons/cannon.tscn").instantiate()
	node.set_script(null)
	tower_selector.add_child(node)


func _on_bat_pressed() -> void:
	var node: = preload("res://Scenes/Weapons/bat.tscn").instantiate()
	node.set_script(null)
	tower_selector.add_child(node)
