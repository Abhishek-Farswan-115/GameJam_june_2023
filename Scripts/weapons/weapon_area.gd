extends Area3D


func _on_mouse_entered() -> void:
	owner.get_node("AttackRange").show()


func _on_mouse_exited() -> void:
	if owner.get_script():
		owner.get_node("AttackRange").hide()
