extends Control

@onready var hover_sound: AudioStreamPlayer = $sound/button_hover_sound
@onready var clicked_sound: AudioStreamPlayer = $sound/button_clicked_sound


func _on_quit_pressed():
	clicked_sound.play()
	await get_tree().create_timer(0.10).timeout
	get_tree().quit()


func _on_retry_pressed():
	clicked_sound.play()
	await get_tree().create_timer(0.10).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
#	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	clicked_sound.play()
	await get_tree().create_timer(0.10).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	pass


func _on_button_mouse_entered():
	hover_sound.pitch_scale = randf_range(0.98, 1.12)
	hover_sound.play()
