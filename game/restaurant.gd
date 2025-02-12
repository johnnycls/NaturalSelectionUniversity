class_name Restaurant

const FOOD_POISON_PROB = 0.3

var FOODS = [
	{"name": tr("FOOD_0"), "cost": 10, "effect": {"hunger": 50, "time": 1, "mood": -10}, "is_tasty": false},
	{"name": tr("FOOD_1"), "cost": 20, "effect": {"hunger": 30, "mood": 15}, "is_tasty": true},
	{"name": tr("FOOD_2"), "cost": 20, "effect": {"hunger": 20, "strength": 5, "mood": -5, "time": 1}, "is_tasty": false},
	{"name": tr("FOOD_3"), "cost": 20, "effect": {"hunger": 25, "intelligence": 7, "mood": -10, "time": 1}, "is_tasty": false},
	{"name": tr("FOOD_4"), "cost": 20, "effect": {"hunger": 20, "luck": 15, "mood": 15}, "is_tasty": true},
	{"name": tr("FOOD_5"), "cost": 20, "effect": {"hunger": 25, "spirit": 30}, "is_tasty": true},
	{"name": tr("FOOD_6"), "cost": 20, "effect": {"hunger": 25, "hp": 40}, "is_tasty": true},
	{"name": tr("FOOD_7"), "cost": 15, "effect": {"spirit": 50}, "is_tasty": true}
]
var date: int = -1
var food_choices: Array = []

func _init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	food_choices = saved_dict.get("food_choices", [])

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
waiter: RESTAURANT_2
do Game.back_to_map()""" % [
	"%s: $%s" % [food_choices[0].name, food_choices[0].cost], food_choices[0].cost, 
	"%s: $%s" % [food_choices[1].name, food_choices[1].cost], food_choices[1].cost, 
	"%s: $%s" % [food_choices[2].name, food_choices[2].cost], food_choices[2].cost, 
]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = FOODS.duplicate(true)
	all_choices.shuffle()
	var random_choices = all_choices.slice(0, choices)
	date = State.progress.date
	State.merge_progress({"restaurant": {"date": State.progress.date, "item_choices": random_choices}})
	return random_choices
	
func start_timeline():
	if State.progress.date != date:
		food_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func before_eat(is_mouse: bool) -> bool: # is_poison
	if randf() < FOOD_POISON_PROB:
		if is_mouse:
			Game.update_status({"bag": {3: -1}})
		else:
			Game.update_status({})
		return true
	return false

func eat(idx: int) -> bool: # is_tasty
	var food = food_choices[idx]
	Game.update_status(food.effect)
	return food.is_tasty
