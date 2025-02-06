class_name Bag

var ITEMS = [
	{"name": "ITEM_0", "effect": {}},
	{"name": "ITEM_1", "effect": {}},
	{"name": "ITEM_2", "effect": {}},
	{"name": "ITEM_3", "effect": {}},
	{"name": "ITEM_4", "effect": {}},
	{"name": "ITEM_5", "effect": {}},
	{"name": "ITEM_6", "effect": {}},
	{"name": "ITEM_7", "effect": {}},
	{"name": "ITEM_8", "effect": {}},
	{"name": "ITEM_9", "effect": {}},
]

func use_item(idx: int) -> void:
	Game.update_status(ITEMS[idx].effect.merged({"bag": {idx: -1}}))
