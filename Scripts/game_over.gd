extends Control

func _on_quit_pressed():
	await get_tree().create_timer(0.10).timeout
	get_tree().quit()


func _on_retry_pressed():
	await get_tree().create_timer(0.10).timeout
	get_tree().reload_current_scene()


func _on_main_menu_pressed():
	await get_tree().create_timer(0.10).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
	pass
