extends Node3D


@onready var grid_map: GridMap = $"../GridMap"
@onready var on_path: Node3D = $"../OnPath"


func _process(_delta: float) -> void:
	var mouse_pos: = get_viewport().get_mouse_position()
	var ray_origin: = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var ray_target: = get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * 10000
	var space_state: = get_world_3d().direct_space_state
	var intersection: = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_target))
	if !intersection.is_empty():
		var pos: = grid_map.map_to_local(grid_map.local_to_map(intersection.position))
		if pos.y == 2:
			position = pos


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate"):
		rotate_y(-PI / 2)
	elif event.is_action_pressed("rmb"):
		for i in get_children():
			i.queue_free()
	elif event.is_action_pressed("lmb") and get_child_count() == 1:
		var tower: Node3D = load(get_child(0).scene_file_path).instantiate()
		if get_parent().gold >= tower.cost:
			on_path.add_child(tower)
			tower.global_position = global_position
			tower.global_rotation = get_child(0).global_rotation
			get_parent().gold -= tower.cost
		else:
			tower.queue_free()


func _on_child_entered_tree(_node: Node) -> void:
	if get_child_count() == 2:
		get_child(0).queue_free()
