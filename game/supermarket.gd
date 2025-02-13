class_name Supermarket

var ITEMS = [
	{"name": "ITEM_0", "cost": 15, "id": 0},
	{"name": "ITEM_1", "cost": 25, "id": 1},
	{"name": "ITEM_2", "cost": 60, "id": 2},
	{"name": "ITEM_3", "cost": 40, "id": 3},
	{"name": "ITEM_4", "cost": 40, "id": 4},
	{"name": "ITEM_5", "cost": 40, "id": 5},
	{"name": "ITEM_6", "cost": 85, "id": 6},
	{"name": "ITEM_7", "cost": 30, "id": 7},
	{"name": "ITEM_8", "cost": 400, "id": 8},
]
var date: int = -1
var item_choices: Array = []

func _init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	item_choices = saved_dict.get("item_choices", [])

func timeline_events() -> Array:
	return ("""
join sales center
sales: SUPERMARKET_0
label choice
- %s | [if {State.progress.money} >= %s and not Game.is_bag_full()] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(0)
	sales: SUPERMARKET_4
	jump choice
- %s | [if {State.progress.money} >= %s and not Game.is_bag_full()] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(1)
	sales: SUPERMARKET_4
	jump choice
- %s | [if {State.progress.money} >= %s and not Game.is_bag_full()] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(2)
	sales: SUPERMARKET_4
	jump choice
- SUPERMARKET_1
	sales: SUPERMARKET_3
	do Game.back_to_map()""" % [
	"%s: $%s" % [tr(item_choices[0].name), item_choices[0].cost], item_choices[0].cost,
	"%s: $%s" % [tr(item_choices[1].name), item_choices[1].cost], item_choices[1].cost, 
	"%s: $%s" % [tr(item_choices[2].name), item_choices[2].cost], item_choices[2].cost, 
]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = ITEMS.duplicate(true)
	all_choices.shuffle()
	var random_choices = all_choices.slice(0, choices)
	date = State.progress.date
	State.merge_progress({"supermarket": {"date": State.progress.date, "item_choices": random_choices}})
	return random_choices
	
func start_timeline():
	if State.progress.date != date:
		item_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func buy_item(idx: int):
	var item = item_choices[idx]
	Game.update_status({"money": -item.money, "bag": {item.id: 1}})
