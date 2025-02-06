class_name Restaurant

const FOOD_POISON_PROB = 0.3

var FOODS = [
	{"name": "FOOD_0", "cost": 100, "effect": {}},
	{"name": "FOOD_1", "cost": 100, "effect": {}},
	{"name": "FOOD_2", "cost": 100, "effect": {}},
	{"name": "FOOD_3", "cost": 100, "effect": {}},
	{"name": "FOOD_4", "cost": 100, "effect": {}},
	{"name": "FOOD_5", "cost": 100, "effect": {}},
	{"name": "FOOD_6", "cost": 100, "effect": {}},
	{"name": "FOOD_7", "cost": 100, "effect": {}}
]
var date: int = -1
var food_choices: Array = []

func timeline_events() -> Array:
	return ("""
join waiter center
waiter: RESTAURANT_0
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {selected_food} = 0
	jump eat/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {selected_food} = 1
	jump eat/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	set {selected_food} = 2
	jump eat/
- RESTAURANT_1
waiter: RESTAURANT_2""" % [
	"%s: $%s" % [food_choices[0].name, food_choices[0].cost], food_choices[0].cost, 
	"%s: $%s" % [food_choices[1].name, food_choices[1].cost], food_choices[1].cost, 
	"%s: $%s" % [food_choices[2].name, food_choices[2].cost], food_choices[2].cost, 
]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = FOODS.duplicate(true)
	all_choices.shuffle()
	return all_choices.slice(0, choices)
	
func start_timeline():
	if State.progress.date != date:
		food_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)
