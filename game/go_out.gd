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

func _init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)

func go_out() -> void:
	if date<State.progress.get(date, 0):
		State.merge_progress({"go_out": {"date": State.progress.date}})
		var event = choose_event()
		match event:
			"steal":
				Game.start_steal()
			"bully":
				Game.start_bully()
			"":
				Game.update_status({"luck": -5})
				Game.back_to_map()
	else:
		Game.back_to_map()

func steal(desire: int, item_id: int):
	match desire:
		0: # money
			Game.update_status({"paper": -2, "hp": -20, "luck": 25})
		1: # hp
			Game.update_status({"paper": -2, "money": -500, "luck": 25})
		2: # paper
			Game.update_status({"hp": -20, "money": -500, "luck": 25})
		3: # all
			match item_id:
				-1: # fist
					var robber_strength = randi_range(50, 150)
					var damage = max(State.progress.get("strength", 0)-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 25})
				0: # knife
					var robber_strength = randi_range(50, 150)
					var damage = max(State.progress.get("strength", 0)*2-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 25, "bag": {0: -1}})
				1: # grenade
					Game.update_status({"hp": -10, "luck": 25, "bag": {1: -1}})
				7: # cloak
					Game.update_status({"luck": 25, "bag": {7: -1}})

func bully(decision: int, item_id: int):
	match decision:
		0: # help
			match item_id:
				-1: # fist
					var robber_strength = randi_range(25, 75)
					var damage = max(State.progress.get("strength", 0)-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 25})
				0: # knife
					var robber_strength = randi_range(25, 75)
					var damage = max(State.progress.get("strength", 0)*2-robber_strength, 0)
					Game.update_status({"hp": damage, "luck": 25, "bag": {0: -1}})
				1: # grenade
					Game.update_status({"hp": -10, "luck": 25, "bag": {1: -1}})
		1: # not help
			Game.update_status({"luck": -25})
