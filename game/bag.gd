class_name Bag

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

func use_item(id: int) -> void:
	if id==6:
		var new_bag = State.progress.get("bag", {}).duplicate(true)
		new_bag[6] -= 1
		State.merge_progress({"hp": randi_range(1,100), "hunger": randi_range(1,100), "spirit": randi_range(1,100), "mood": randi_range(1,100), "bag": new_bag})
	else:
		var item = ITEMS.filter(func(i): return i.id==id)
		if item.size()>0:
			Game.update_status(item[0].effect.merged({"bag": {id: -1}}))
