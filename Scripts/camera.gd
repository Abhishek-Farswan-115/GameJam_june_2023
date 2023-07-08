extends Camera3D


@export var speed: = 5.0
@export var max_zoom: = 20.0
@export var min_zoom: = 5.0


func _process(delta: float) -> void:
	position.x += (Input.get_action_strength("right") - Input.get_action_strength("left")) * delta * speed * size
	position.z += (Input.get_action_strength("down") - Input.get_action_strength("up")) * delta * speed * size


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		position.y = max(position.y - 1, min_zoom)
	elif event.is_action_pressed("zoom_out"):
		position.y = min(position.y + 1, max_zoom)
