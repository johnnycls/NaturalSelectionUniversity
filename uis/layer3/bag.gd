extends PanelContainer

func _ready() -> void:
	pass

func close() -> void:
	Main.close_popup()

func use_item(idx: int) -> void:
	var original_bag = State.progress.get("bag", [])
	var item_id = original_bag[idx]
	if item_id==6:
		var new_bag = original_bag.duplicate(true)
		new_bag.remove_at(idx)
		State.merge_progress({"hp": randi_range(5,100), "hunger": randi_range(5,100), "spirit": randi_range(5,100), "mood": randi_range(5,100), "bag": new_bag})
	else:
		var item = Config.ITEMS.filter(func(i): return i.id==item_id)
		if item.size()>0:
			Game.update_status(item[0].effect.merged({"bag": {item_id: -1}}))
