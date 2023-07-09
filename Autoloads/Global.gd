extends Node

const Game_scene = {
	"game world" : "res://Scenes/Level/level.tscn"
}

var loading_screen = preload("res://Scenes/UI/loading_screen.tscn")
var loading_scene_instance: CanvasLayer
var load_path: String


func _ready() -> void:
	set_process(false)


func _process(_delta: float) -> void:
	var load_progress: = []
	var load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)
	
	match load_status:
		0:
			print("resource invalid, can't load")
		1:
			loading_scene_instance.update_progress(load_progress[0])
			return
		2:
			print("error loading!")
		3:
			var next_scene_instansiate = ResourceLoader.load_threaded_get(load_path).instantiate()
			get_tree().get_root().call_deferred("add_child", next_scene_instansiate)
			loading_scene_instance.fade_out()
	set_process(false)


func load_scene(current_scene, next_scene):
	loading_scene_instance = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add_child", loading_scene_instance)
	
	if Game_scene.has(next_scene):
		load_path = Game_scene[next_scene]
	else:
		load_path = next_scene
		
	var loader_next_scene
	if ResourceLoader.exists(load_path):
		loader_next_scene = ResourceLoader.load_threaded_request(load_path)
	
	if loader_next_scene == null:
		print("error loading scene!")
		return
		
	current_scene.queue_free()
	await loading_scene_instance.safe_to_load
	set_process(true)
