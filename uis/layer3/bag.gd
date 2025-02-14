extends PanelContainer

var ITEMS = [
	{"id": 0, "name": "ITEM_0", "effect": {}, "usable": false},
	{"id": 1, "name": "ITEM_1", "effect": {}, "usable": false},
	{"id": 2, "name": "ITEM_2", "effect": {}, "usable": false},
	{"id": 3, "name": "ITEM_3", "effect": {"spirit": 60}, "usable": true},
	{"id": 4, "name": "ITEM_4", "effect": {}, "usable": false},
	{"id": 5, "name": "ITEM_5", "effect": {"mood": 65}, "usable": true},
	{"id": 6, "name": "ITEM_6", "effect": {}, "usable": true},
	{"id": 7, "name": "ITEM_7", "effect": {}, "usable": false},
	{"id": 8, "name": "ITEM_8", "effect": {}, "usable": false},
]

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
		var item = ITEMS.filter(func(i): return i.id==item_id)
		if item.size()>0:
			Game.update_status(item[0].effect.merged({"bag": {item_id: -1}}))
