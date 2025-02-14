class_name GoOut

var date: int = -1

func events() -> Dictionary:
	return {
		"steal": 100-State.progress.get("luck", 0),
		"bully": 5,
		"insurance": 5,
		"merchant": 10,
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
			"insurance":
				Game.start_insurance()
			"merchant":
				Game.start_merchant()
			"":
				Game.update_status({"luck": -5})
				Game.back_to_map()
	else:
		Game.back_to_map()
