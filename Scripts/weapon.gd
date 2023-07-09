extends Node3D


@export var attack_speed: = 2.0
@export var damage: = 10
@export var projectile: PackedScene
@export var aim_tile: MeshInstance3D
@export var cost: = 500

var _enemies: = []
var _timer: = Timer.new()
var _can_attack: = true

@onready var scanner: Area3D = $Scanner
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D


func _ready() -> void:
	$AttackRange.hide()
	
	scanner.area_entered.connect(_on_scanner_area_entered)
	scanner.area_exited.connect(_on_scanner_area_exited)
	
	add_child(_timer)
	_timer.timeout.connect(func(): _can_attack = true)


func _process(_delta: float) -> void:
	if _can_attack and !_enemies.is_empty():
		attack()



func attack() -> void:
	_timer.start()
	_can_attack = false
	audio_stream_player_3d.play()
	var tween: = create_tween()
	if projectile:
		var p: = projectile.instantiate()
		add_child(p)
		tween.tween_property(p, "position", aim_tile.position, 0.2)
		tween.finished.connect(p.queue_free)
	else:
		tween.tween_property(self, "global_position", aim_tile.global_position, 0.1)
		tween.tween_property(self, "global_position", global_position, 0.1)
	await get_tree().create_timer(0.2).timeout
	for i in _enemies:
		i.take_damge(damage)


func _on_scanner_area_entered(area: Area3D) -> void:
	_enemies.push_back(area.owner)


func _on_scanner_area_exited(area: Area3D) -> void:
	_enemies.erase(area.owner)
