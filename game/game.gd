extends Node2D

var map_scene = preload("res://uis/layer1/map.tscn")
var hospital = preload("res://game/hospital.gd").new()
var lecture = preload("res://game/lecture.gd").new(State.progress.get("lecture", {}))
var paper = preload("res://game/paper.gd").new()
var restaurant = preload("res://game/restaurant.gd").new(State.progress.get("restaurant", {}))
var sleep = preload("res://game/sleep.gd").new()
var supermarket = preload("res://game/supermarket.gd").new(State.progress.get("supermarket", {}))

var _current_scene: Node

func _remove_scene() -> void:
	if Global.is_node_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
		
func start_intro() -> void:
	BgmPlayer.play_bgm(4)
	State.merge_progress(Config.INIT_PROGRESS)
	Dialogic.start("intro")

func start_ceremony() -> void:
	State.merge_progress({"is_intro_finished": true})
	BgmPlayer.play_bgm(5)
	Dialogic.start("ceremony")
	
func ended_ceremony() -> void:
	State.merge_progress({"is_ceremony_finished": true})
	back_to_map()
	
func back_to_map() -> void:
	Dialogic.end_timeline()
	BgmPlayer.play_bgm(6)
	Main.change_ui(map_scene.instantiate())
	Main.show_status_bar()
	
func start_hospital() -> void:
	BgmPlayer.play_bgm(3)
	Dialogic.start("hospital")
	Main.clear_ui()
	
func start_restaurant() -> void:
	BgmPlayer.play_bgm(1)
	restaurant.start_timeline()
	Main.clear_ui()
	
func start_home() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("home")
	Main.clear_ui()
	
func start_supermarket() -> void:
	BgmPlayer.play_bgm(8)
	supermarket.start_timeline()
	Main.clear_ui()
	
func start_lecture() -> void:
	BgmPlayer.play_bgm(5)
	lecture.start_timeline()
	Main.clear_ui()
	
func start_game() -> void:
	if not State.progress.get("is_intro_finished", false):
		start_intro()
	elif not State.progress.get("is_ceremony_finished", false):
		start_ceremony()
	else:
		back_to_map()
		
func end_game() -> void:
	Dialogic.end_timeline()
	Main.back_to_home_screen()

# delta: {"hp": -1, "bag": {0: -1}}
func update_status(delta: Dictionary) -> void:
	var new_progress = _compute_new_progress(State.progress, delta)
	State.merge_progress(new_progress)

func _compute_new_progress(current_progress: Dictionary, delta: Dictionary) -> Dictionary:
	var new_progress = current_progress.duplicate(true)
	for key in delta:
		match key:
			"bag":
				new_progress.bag = _update_bag(new_progress.get("bag", {}), delta.bag)
			"time":
				new_progress = _update_time(new_progress, delta.time)
			_:
				new_progress[key] = _update_stat(new_progress.get(key, 0), delta[key], key)
	return new_progress

func _update_bag(current_bag: Dictionary, delta_bag: Dictionary) -> Dictionary:
	var new_bag = current_bag.duplicate()
	for item_id in delta_bag:
		new_bag[item_id] = new_bag.get(item_id, 0) + delta_bag[item_id]
	return new_bag

func _update_time(current_progress: Dictionary, delta_time: int) -> Dictionary:
	var new_progress = current_progress.duplicate()
	var original_time = current_progress.get("time", 0)
	var total_time = original_time + delta_time
	new_progress.time = total_time % 24
	var new_date = total_time / 24
	if new_date != 0:
		new_progress.date = new_date
	return new_progress

func _update_stat(current_value: int, delta_value: int, key: String) -> int:
	var new_value = current_value + delta_value
	if Config.MAX_PROGRESS.has(key):
		new_value = min(new_value, Config.MAX_PROGRESS[key])
	if key in ["hunger", "spirit", "hp"] and new_value < 0:
		handle_death()
	return new_value

func handle_death() -> void:
	end_game()
