extends CanvasLayer

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound


func _on_back_pressed():
	clicked_sound.play()
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	

func _on_back_mouse_entered():
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()
