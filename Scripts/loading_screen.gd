class_name LoadingScreen extends CanvasLayer


signal safe_to_load

@onready var animplayer = $AnimationPlayer
@onready var progress_bar: ProgressBar = $Control/ProgressBar


func fade_out():
	animplayer.play("Fade Out")
	await animplayer.animation_finished
	queue_free()


func update_progress(val: float) -> void:
	progress_bar.value = val*100.0
