class_name Adventurer extends Node3D


@export var move_speed: = 10
@export var health: = 100
@export var run_animation: = ""
@export var gold_drop: = 50
@export var gold_loot: = 100

var path: Array
var health_bar: TextureProgressBar = null

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	global_position = path.back()
	look_at(path[path.size() - 2])
	animation_player.play(run_animation)
	add_child(preload("res://Scripts/adventurers/interact.tscn").instantiate())
	$Interact.area_entered.connect(_on_interact_area_entered)
	$Interact.owner = self
	add_child(preload("res://Scenes/UI/health_bar.tscn").instantiate())
	health_bar = $HealthBar/SubViewport/EnemyHealthBar
	health_bar.max_value = health
	health_bar.value = health 


func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(path.back(), move_speed * delta)
	if global_position == path.back():
		while !path.is_empty() and global_position == path.back():
			path.pop_back()
		if path.is_empty():
			queue_free()
			get_tree().root.get_node("Level").gold -= gold_loot
		else:
			look_at(path.back())


func _on_interact_area_entered(_area: Area3D) -> void:
	set_physics_process(false)
	animation_player.play("Loot")
	await animation_player.animation_finished
	set_physics_process(true)
	animation_player.play(run_animation)


func take_damge(damage: int) -> void:
	health_bar.value -= damage
	if health_bar.value == 0:
		prints(get_tree(), get_tree().root, get_child(0))
		get_tree().root.get_node("Level").gold += gold_drop
		queue_free()
