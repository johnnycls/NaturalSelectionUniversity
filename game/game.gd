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

func update_status(delta: Dictionary) -> void:
	var new_delta = {}
	for key in delta:
		new_delta[key] = min(Config.MAX_PROGRESS.get(key, 0), State.progress.get(key, 0) + delta[key])
		if Config.END_GAME_PROGRESS.has(key) && State.progress.get(key, 0) + delta[key] < Config.END_GAME_PROGRESS[key]:
			end_game()
	State.update_progress(new_delta)
