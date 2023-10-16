extends Control


signal pressed

var target: Vector3

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var highlight: TextureRect = $TextureProgressBar/Highlight
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar
@onready var timer: Timer = $Timer


func _process(_delta: float) -> void:
	position = get_viewport().get_camera_3d().unproject_position(target) - get_rect().size / 2
	texture_progress_bar.value = timer.wait_time - timer.time_left
	


func _gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		_pressed()


func start(time: float) -> void:
	timer.wait_time = time
	timer.start()
	texture_progress_bar.max_value = time
	show()


func _pressed() -> void:
	pressed.emit()
	timer.stop()
	animation_player.stop()
	scale = Vector2.ONE
	hide()


func _on_mouse_entered() -> void:
	highlight.show()


func _on_mouse_exited() -> void:
	highlight.hide()


func _on_timer_timeout() -> void:
	_pressed()
