extends Camera3D


@export var speed: = 5.0
@export var max_zoom: = 20.0
@export var min_zoom: = 5.0

@onready var destination: = position
@onready var zoom: = position.y


func _process(delta: float) -> void:
	destination.x += (Input.get_action_strength("right") - Input.get_action_strength("left")) * delta * speed * size
	destination.z += (Input.get_action_strength("down") - Input.get_action_strength("up")) * delta * speed * size
	position.x = lerpf(position.x, destination.x, delta * 40)
	position.z = lerpf(position.z, destination.z, delta * 40)
	position.y = lerpf(position.y, zoom, delta * 10)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		if zoom / 1.5 >= min_zoom:
			zoom /= 1.5
	elif event.is_action_pressed("zoom_out"):
		if zoom * 1.5 <= max_zoom:
			zoom *= 1.5
