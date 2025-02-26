class_name GoOut

var draw_sword_sound = preload("res://assets/audio/draw-sword.mp3")
var explosion_sound = preload("res://assets/audio/explosion.mp3")
var fall_sound = preload("res://assets/audio/fall.mp3")
var punch_sound = preload("res://assets/audio/punch.mp3")

var date: int = -1

func events() -> Dictionary:
	return {
		"steal": 25,
		"bully": 25,
		"": 50,
	}

func choose_event() -> String:
	var event_dict = events()
	var total_weight = event_dict.values().reduce(func (acc, cur): return acc+cur, 0)
	var random_value = randf() * total_weight
	for event in event_dict.keys():
		random_value -= event_dict[event]
		if random_value <= 0:
			return event
	return ""

func init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)

func go_out() -> void:
	if date<Global.get_date():
		State.merge_progress({"go_out": {"date": Global.get_date()}})
		var event = choose_event()
		match event:
			"steal":
				Game.start_steal()
			"bully":
				Game.start_bully()
			"":
				Game.update_status({"luck": -10})
				Game.back_to_map()
	else:
		Game.back_to_map()

func steal(desire: int, item_id: int):
	match desire:
		0: # money
			Game.update_status({"paper": -2000, "hp": -20, "luck": 10, "mood": -10})
		1: # hp
			Game.update_status({"paper": -2000, "money": -500, "luck": 10, "mood": -10})
		2: # paper
			Game.update_status({"hp": -20, "money": -500, "luck": 10, "mood": -10})
		3: # all
			match item_id:
				-1: # fist
					var robber_strength = randi_range(10, 15) * Global.get_date()
					var damage = max(robber_strength-State.progress.get("strength", 0), 0)
					Global.play_sound(punch_sound)
					Game.update_status({"hp": -damage, "luck": 10})
				0: # knife
					var robber_strength = randi_range(10, 15) * Global.get_date()
					var damage = max(robber_strength-(State.progress.get("strength", 0)*2), 0)
					Global.play_sound(draw_sword_sound)
					var new_bag = Game.remove_bag_item(0)
					Game.update_status({"hp": -damage, "luck": 10, "bag": new_bag})
				1: # grenade
					Global.play_sound(explosion_sound)
					var new_bag = Game.remove_bag_item(1)
					Game.update_status({"hp": -10, "luck": 10, "bag": new_bag})
				7: # cloak
					var new_bag = Game.remove_bag_item(7)
					Game.update_status({"luck": 10, "bag": new_bag})

func bully(decision: int, item_id: int):
	match decision:
		0: # help
			match item_id:
				-1: # fist
					var robber_strength = randi_range(5, 10) * Global.get_date()
					var damage = max(robber_strength-State.progress.get("strength", 0), 0)
					Global.play_sound(punch_sound)
					Game.update_status({"hp": -damage, "luck": 20, "mood": 20, "time": 30})
				0: # knife
					var robber_strength = randi_range(5, 10) * Global.get_date()
					var damage = max(robber_strength-(State.progress.get("strength", 0)*2), 0)
					Global.play_sound(draw_sword_sound)
					var new_bag = Game.remove_bag_item(0)
					Game.update_status({"hp": -damage, "luck": 20, "bag": new_bag, "mood": 20, "time": 30})
				1: # grenade
					Global.play_sound(explosion_sound)
					var new_bag = Game.remove_bag_item(1)
					Game.update_status({"hp": -10, "luck": 20, "bag": new_bag, "mood": 20, "time": 30})
		1: # not help
			Game.update_status({"luck": -25, "mood": -10})
