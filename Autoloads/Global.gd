extends Node

const Game_scene = {
	"game world" : "  "
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var loading_screen = preload("res://Scenes/UI/loading_screen.tscn")

func load_scene(current_scene, next_scene):
	var loading_scene_instance = loading_screen.instantiate()
	get_tree().get_root().call_deferred("add child", loading_scene_instance)
	
	var load_path : String
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
		
	await loading_scene_instance.safe_to_load
	current_scene.queue_free()
	
	while true:
		var load_progress
		var load_status = ResourceLoader.load_threaded_get_status(load_path, load_progress)
		
		match load_status:
			0:
				print("resource invalid, can't load")
				return
			1:
				loading_scene_instance.get_node("Control/ProgressBar").value = load_progress
			2:
				print("error loading!")
				return
			3:
				var next_scene_instansiate = ResourceLoader.load_threaded_get(load_path).instantiate()
				get_tree().get_root().call_deferred("add child", next_scene_instansiate)
				loading_scene_instance.fade_out()
				return



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


