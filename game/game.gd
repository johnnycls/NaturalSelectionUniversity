extends Node2D

var map_scene = preload("res://uis/layer1/map.tscn")
var hospital = preload("res://game/hospital.gd").new()
var lecture = preload("res://game/lecture.gd").new()
var paper = preload("res://game/paper.gd").new()
var restaurant = preload("res://game/restaurant.gd").new()
var sleep = preload("res://game/sleep.gd").new()
var supermarket = preload("res://game/supermarket.gd").new()

var _current_scene: Node

func _remove_scene() -> void:
	if Global.is_node_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
	
func start_game() -> void:
	if not State.progress.get("is_intro_finished", false):
		State.merge_progress(Config.INIT_PROGRESS)
		Dialogic.start("intro")
	elif not State.progress.get("is_ceremony_finished", false):
		Dialogic.start("ceremony")
	else:
		Main.change_ui(map_scene.instantiate())
		
func end_game() -> void:
	Dialogic.end_timeline()
	_remove_scene()

func back_to_map():
	Dialogic.end_timeline()
	Main.change_ui(map_scene.instantiate())

# delta: {"hp": -1, "bag": {0: -1}}
func update_status(delta: Dictionary) -> void:
	var new_progress = {"bag": State.progress.get("bag", {})}
	for key in delta:
		if key=="bag":
			for item_id in delta[key]:
				new_progress.bag[item_id] = new_progress.bag.get(item_id, 0) + delta[key][item_id]
		else:
			new_progress[key] = State.progress.get(key, 0) + delta[key]
			
			if Config.MAX_PROGRESS.has(key) && new_progress[key] > Config.MAX_PROGRESS[key]:
				new_progress[key] = Config.MAX_PROGRESS[key]
			
			if ["hunger", "spirit", "hp"].has(key) && new_progress[key]<0:
				pass # die
	State.merge_progress(new_progress)
