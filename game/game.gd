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
	
func start_bad_end() -> void:
	BgmPlayer.play_bgm(0)
	Dialogic.start("bad_end")
	Main.clear_ui()
	
func start_good_end() -> void:
	BgmPlayer.play_bgm(4)
	Dialogic.start("good_end")
	Main.clear_ui()
	
func start_normal_end() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("normal_end")
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

# delta: {"hp": -1, "bag": {0: -1}}
func update_status(delta: Dictionary) -> void:
	var new_progress = _compute_new_progress(delta)
	State.merge_progress(new_progress)
	if new_progress.get("hunger", 0) < 0 or new_progress.get("spirit", 0) < 0 or new_progress.get("hp", 0) < 0:
		start_bad_end()
	elif new_progress.get("date", 0) >= 100 and new_progress.paper>=100:
		start_good_end()
	elif new_progress.get("date", 0) >= 100:
		start_normal_end()

func _compute_new_progress(delta: Dictionary) -> Dictionary:
	var new_progress = State.progress.duplicate(true)
	for key in delta:
		match key:
			"bag":
				new_progress.bag = _updated_bag(new_progress.get("bag", {}), delta.bag)
			"time":
				var new_datetime = _updated_datetime(new_progress, delta.time)
				new_progress.date = new_datetime.date
				new_progress.time = new_datetime.time
			_:
				new_progress[key] = _updated_stat(new_progress.get(key, 0), delta[key], key)
	return new_progress

func _updated_bag(current_bag: Dictionary, delta_bag: Dictionary) -> Dictionary:
	var new_bag = current_bag.duplicate(true)
	for item_id in delta_bag:
		new_bag[item_id] = new_bag.get(item_id, 0) + delta_bag[item_id]
	return new_bag

func _updated_datetime(current_progress: Dictionary, delta_time: int) -> Dictionary:
	var original_date = current_progress.get("date", 0)
	var original_time = current_progress.get("time", 0)
	var total_time = int(original_time + delta_time)
	var new_date = original_date + total_time / 24
	var new_time = total_time % 24
	return {"date": new_date, "time": new_time}

func _updated_stat(current_value: int, delta_value: int, key: String) -> int:
	var new_value = current_value + delta_value
	if Config.MAX_PROGRESS.has(key):
		new_value = min(new_value, Config.MAX_PROGRESS[key])
	return new_value

func is_bag_full() -> bool:
	var bag = State.progress.get("bag", {})
	var total_items = 0
	for item_id in bag:
		total_items += bag[item_id]
	return total_items > Config.BAG_VOLUME
