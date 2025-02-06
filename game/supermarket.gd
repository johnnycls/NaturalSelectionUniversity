class_name Supermarket

var ITEMS = [
	{"name": "ITEM_0", "cost": 250, "id": 0},
	{"name": "ITEM_1", "cost": 100, "id": 1},
	{"name": "ITEM_2", "cost": 350, "id": 2},
	{"name": "ITEM_3", "cost": 75, "id": 3},
	{"name": "ITEM_4", "cost": 50, "id": 4},
	{"name": "ITEM_5", "cost": 100, "id": 5},
	{"name": "ITEM_6", "cost": 100, "id": 6},
	{"name": "ITEM_7", "cost": 250, "id": 7},
	{"name": "ITEM_8", "cost": 800, "id": 8},
	{"name": "ITEM_9", "cost": 500, "id": 9},
]
var date: int = -1
var item_choices: Array = []

func timeline_events() -> Array:
	return ("""
join sales center
sales: SUPERMARKET_0
label choice
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(0)
	sales: SUPERMARKET_4
	jump choice
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(1)
	sales: SUPERMARKET_4
	jump choice
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(2)
	sales: SUPERMARKET_4
	jump choice
- SUPERMARKET_1
sales: SUPERMARKET_3""" % [
	"%s: $%s" % [item_choices[0].name, item_choices[0].cost], item_choices[0].cost,
	"%s: $%s" % [item_choices[1].name, item_choices[1].cost], item_choices[1].cost, 
	"%s: $%s" % [item_choices[2].name, item_choices[2].cost], item_choices[2].cost, 
]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = ITEMS.duplicate(true)
	all_choices.shuffle()
	return all_choices.slice(0, choices)
	
func start_timeline():
	if State.progress.date != date:
		item_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func buy_item(idx: int):
	var item = item_choices[idx]
	Game.update_status({"money": -item.money, "bag": {item.id: 1}})
