@tool
extends GridMap


@export var gen: = false:
	set(_value):
		generate()
@export var map_width: = 64
@export var map_height: = 64


var _grid: = AStarGrid2D.new()
var _noise: = FastNoiseLite.new()
var _path: = PackedVector2Array()
var _middle_path: = PackedVector2Array()

@onready var on_path: Node3D = $"../OnPath"


func _init() -> void:
	_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	_grid.region = Rect2i(0, 0, map_width, map_height)
	_grid.update()
	_noise.frequency = 0.02


func _ready() -> void:
	for x in map_width:
		for y in map_height: 
			set_cell_item(Vector3i(x, 0, y), 89)
	generate()


func generate() -> void:
	_reset()
	_create_path()
	_set_item()


func _reset() -> void:
	for i in _path:
		set_cell_item(Vector3i(i.x, 0, i.y), 89)
	_noise.frequency = 0.05
	_noise.seed = randi()
	
	for child in on_path.get_children():
		child.queue_free()


func _create_path() -> void:
	for x in map_width:
		for y in map_height:
			_grid.set_point_weight_scale(Vector2i(x, y), pow((_noise.get_noise_2d(x, y) + 1), 10))
	
	_middle_path = _grid.get_point_path(
		Vector2i(1, randi_range(map_height * 0.2, map_height * 0.8)),
		Vector2i(map_width - 2, randi_range(map_height * 0.2, map_height * 0.8))
	)
	_middle_path = PackedVector2Array([
		_middle_path[0] - Vector2(5, 0),
		_middle_path[0] - Vector2(4, 0),
		_middle_path[0] - Vector2(3, 0),
		_middle_path[0] - Vector2(2, 0),
		_middle_path[0] - Vector2(1, 0),
	]) + _middle_path
	for i in _middle_path.size():
		if i - 2 >= 0 and i + 2 < _middle_path.size():
			if abs(_middle_path[i - 1] - _middle_path[i + 1]) == Vector2.ONE and abs(_middle_path[i - 2] - _middle_path[i + 2]) == Vector2(2, 2):
				_middle_path[i] = 2 * _middle_path[i - 1] - _middle_path[i - 2]
	
	var coords: = {}
	for i in _middle_path:
		for x in range(i.x - 1, i.x + 2):
			for y in range(i.y - 1, i.y + 2):
				coords[Vector2i(x, y)] = null
	_path = coords.keys()
	
	for i in coords:
		set_cell_item(Vector3i(i.x, 0, i.y), 84)


func _set_item() -> void:
	var chest: = preload("res://Resources/KayKit_DungeonRemastered/chest_gold.glb").instantiate()
	on_path.add_child(chest)
	var last_point: = _middle_path[_middle_path.size() - 1]
	chest.global_position = to_global(map_to_local(Vector3i(last_point.x, 0, last_point.y)))
	
	for i in 10:
		var torch: = preload("res://Scenes/Level/torch.tscn").instantiate()
		on_path.add_child(torch)
		var rand_point: = _get_random_point_next_to_path(3)
		while _path.has(rand_point):
			rand_point = _get_random_point_next_to_path(3)
		torch.global_position = to_global(map_to_local(Vector3i(rand_point.x, 1, rand_point.y)))


func _get_random_point_next_to_path(distance: int) -> Vector2:
	var point: = _middle_path[randi() % (_middle_path.size() - 5) + 5]
	match randi() % 4:
		0:
			point += Vector2(randi_range(-2 - distance, 2 + distance), -2)
		1:
			point += Vector2(randi_range(-2 - distance, 2 + distance), 2)
		2:
			point += Vector2(-2, randi_range(-2 - distance, 2 + distance))
		3:
			point += Vector2(2, randi_range(-2 - distance, 2 + distance))
	return point
