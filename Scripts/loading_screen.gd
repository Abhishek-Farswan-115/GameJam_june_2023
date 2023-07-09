class_name LoadingScreen extends CanvasLayer

signal safe_to_load

@onready var animplayer = $AnimationPlayer

func fade_out():
	animplayer.play("Fade Out")
	await animplayer.animation_finished
	queue_free()
func update_progress(val: float) -> void:
	$VBoxContainer/MarginContainer/ProgressBar.value = val*100.0
