extends Node3D


@export var move_speed: = 10
@export var run_animation: = ""

var path: Array

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	global_position = path.back()
	look_at(path[path.size() - 2])
	animation_player.play(run_animation)


func _physics_process(delta: float) -> void:
	global_position = global_position.move_toward(path.back(), move_speed * delta)
	if global_position == path.back():
		while !path.is_empty() and global_position == path.back():
			path.pop_back()
		if path.is_empty():
			queue_free()
		else:
			look_at(path.back())


func _on_interact_area_entered(_area: Area3D) -> void:
	set_physics_process(false)
	animation_player.play("Loot")
	await animation_player.animation_finished
	set_physics_process(true)
	animation_player.play(run_animation)
