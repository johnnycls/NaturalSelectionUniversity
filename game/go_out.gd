class_name GoOut

var date: int = -1

func events() -> Dictionary:
	return {
		"steal": 100-State.progress.get("luck", 0),
		"bully": 5,
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
			Game.update_status({"paper": -200, "hp": -20, "luck": 20})
		1: # hp
			Game.update_status({"paper": -200, "money": -500, "luck": 20})
		2: # paper
			Game.update_status({"hp": -20, "money": -500, "luck": 20})
		3: # all
			match item_id:
				-1: # fist
					var robber_strength = randi_range(50, 150)
					var damage = max(State.progress.get("strength", 0)-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 20})
				0: # knife
					var robber_strength = randi_range(50, 150)
					var damage = max(State.progress.get("strength", 0)*2-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 20, "bag": {0: -1}})
				1: # grenade
					Game.update_status({"hp": -10, "luck": 20, "bag": {1: -1}})
				7: # cloak
					Game.update_status({"luck": 20, "bag": {7: -1}})

func bully(decision: int, item_id: int):
	match decision:
		0: # help
			match item_id:
				-1: # fist
					var robber_strength = randi_range(25, 75)
					var damage = max(State.progress.get("strength", 0)-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 30, "mood": 20, "time": 30})
				0: # knife
					var robber_strength = randi_range(25, 75)
					var damage = max(State.progress.get("strength", 0)*2-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 30, "bag": {0: -1}, "mood": 20, "time": 30})
				1: # grenade
					Game.update_status({"hp": -10, "luck": 30, "bag": {1: -1}, "mood": 20, "time": 30})
		1: # not help
			Game.update_status({"luck": -20})
