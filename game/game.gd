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
	var new_progress = {"bag": State.progress.get("bag", {}).duplicate()}

	for key in delta:
		match key:
			"bag":
				update_bag(new_progress.bag, delta.bag)
			"time":
				update_time(new_progress, delta.time)
			_:
				update_stat(new_progress, key, delta[key])

	State.merge_progress(new_progress)

func update_bag(bag: Dictionary, delta_bag: Dictionary) -> void:
	for item_id in delta_bag:
		bag[item_id] = bag.get(item_id, 0) + delta_bag[item_id]

func update_time(new_progress: Dictionary, delta_time: int) -> void:
	var original_time = State.progress.get("time", 0)
	var total_time = original_time + delta_time
	new_progress.time = total_time % 24
	var new_date = total_time / 24
	if new_date != 0:
		new_progress.date = new_date

func update_stat(new_progress: Dictionary, key: String, delta_value: int) -> void:
	new_progress[key] = State.progress.get(key, 0) + delta_value

	if Config.MAX_PROGRESS.has(key):
		new_progress[key] = min(new_progress[key], Config.MAX_PROGRESS[key])

	if key in ["hunger", "spirit", "hp"] && new_progress[key] < 0:
		handle_death()

func handle_death() -> void:
	pass  
