class_name Supermarket

var ITEMS = [
	{"name": "ITEM_0", "cost": 100},
	{"name": "ITEM_1", "cost": 100},
	{"name": "ITEM_2", "cost": 100},
	{"name": "ITEM_3", "cost": 100},
	{"name": "ITEM_4", "cost": 100},
	{"name": "ITEM_5", "cost": 100},
	{"name": "ITEM_6", "cost": 100},
	{"name": "ITEM_7", "cost": 100},
	{"name": "ITEM_8", "cost": 100},
	{"name": "ITEM_9", "cost": 100},
]
var date: int = -1
var item_choices: Array = []

func timeline_events() -> Array:
	return ("""
join sales center
sales: SUPERMARKET_0
label choice
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {item} = 0
	jump buy/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {item} = 1
	jump buy/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {item} = 2
	jump buy/
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
