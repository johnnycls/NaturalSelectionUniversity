extends Node2D

var bell_sound = preload("res://assets/audio/bell.mp3")

var map_scene = preload("res://uis/layer1/map.tscn")
var go_out = preload("res://game/go_out.gd").new()
var hospital = preload("res://game/hospital.gd").new()
var lecture = preload("res://game/lecture.gd").new()
var paper = preload("res://game/paper.gd").new()
var restaurant = preload("res://game/restaurant.gd").new()
var sleep = preload("res://game/sleep.gd").new()
var supermarket = preload("res://game/supermarket.gd").new()

var guide_popup = preload("res://uis/layer3/guide.tscn")

var _current_scene: Node

func _remove_scene() -> void:
	if Global.is_node_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
		
func start_intro() -> void:
	Main.popup(guide_popup.instantiate())
	BgmPlayer.play_bgm(4)
	Dialogic.start("intro")

func start_ceremony() -> void:
	Main.close_popup()
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
	
func start_steal() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("steal")
	Main.clear_ui()
	
func start_bully() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("bully")
	Main.clear_ui()
	
func start_insurance() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("insurance")
	Main.clear_ui()
	
func start_merchant() -> void:
	BgmPlayer.play_bgm(2)
	Dialogic.start("merchant")
	Main.clear_ui()
	
func start_bad_end() -> void:
	BgmPlayer.play_bgm(0)
	Global.play_sound(bell_sound)
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
	go_out.init(State.progress.get("go_out", {}))
	lecture.init(State.progress.get("lecture", {}))
	restaurant.init(State.progress.get("restaurant", {}))
	supermarket.init(State.progress.get("supermarket", {}))
	
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
	var new_date = Global.m2d(new_progress.get("time", 0))
	
	if new_progress.get("hunger", 0) <= 0 or new_progress.get("spirit", 0) <= 0 or new_progress.get("hp", 0) <= 0:
		if 8 in new_progress.get("bag", []):
			var new_bag = Game.remove_bag_item(8)
			State.merge_progress({"bag": new_bag, "hp": max(1, new_progress.get("hp", 0)), "spirit": max(1, new_progress.get("spirit", 0)), "hunger": max(1, new_progress.get("hunger", 0))})
		else:
			start_bad_end()
			
	elif new_date >= Config.TOTAL_DAYS and new_progress.paper>=100000:
		start_good_end()
		
	elif new_date >= Config.TOTAL_DAYS:
		start_normal_end()

func _compute_new_progress(delta: Dictionary) -> Dictionary:
	var new_progress = State.progress.duplicate(true)
	for key in delta:
		match key:
			"bag":
				new_progress.bag = delta.bag
			_:
				new_progress[key] = _updated_stat(new_progress.get(key, 0), delta[key], key)
	return new_progress

func _updated_stat(current_value: int, delta_value: int, key: String) -> int:
	var new_value = current_value + delta_value
	if Config.MAX_PROGRESS.has(key):
		new_value = min(new_value, Config.MAX_PROGRESS[key])
	return new_value

func is_bag_full() -> bool:
	return State.progress.get("bag", []).size() >= Config.BAG_VOLUME

func remove_bag_item(item_id: int) -> Array:
	var new_bag = State.progress.get("bag", []).duplicate(true).map(func(n): return int(n))
	new_bag.erase(item_id)
	return new_bag
