class_name Restaurant

var buy_sound = preload("res://assets/audio/buy.mp3")
var cry_sound = preload("res://assets/audio/cry.mp3")
var sigh_sound = preload("res://assets/audio/sigh.mp3")
var woo_sound = preload("res://assets/audio/woo.mp3")
var yay_sound = preload("res://assets/audio/yay.mp3")

func food_poison_prob() -> float:
	return 0.3

var FOODS = [
	{"name": tr("FOOD_0"), "cost": 15, "effect": {"hunger": 60, "time": 60, "mood": -20}, "is_tasty": false},
	{"name": tr("FOOD_1"), "cost": 20, "effect": {"hunger": 40, "mood": 20, "time": 15}, "is_tasty": true},
	{"name": tr("FOOD_2"), "cost": 25, "effect": {"hunger": 40, "strength": 2, "mood": -10, "time": 60}, "is_tasty": false},
	{"name": tr("FOOD_3"), "cost": 25, "effect": {"hunger": 40, "intelligence": 2, "mood": -10, "time": 60}, "is_tasty": false},
	{"name": tr("FOOD_4"), "cost": 30, "effect": {"hunger": 30, "luck": 20, "mood": 20, "time": 15}, "is_tasty": true},
	{"name": tr("FOOD_5"), "cost": 30, "effect": {"hunger": 40, "spirit": 25, "mood": 5, "time": 30}, "is_tasty": true},
	{"name": tr("FOOD_6"), "cost": 30, "effect": {"hunger": 40, "hp": 25, "time": 30}, "is_tasty": true},
	{"name": tr("FOOD_7"), "cost": 25, "effect": {"spirit": 25, "time": 30}, "is_tasty": true}
]
var date: int = -1
var food_choices: Array = []

func init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	food_choices = saved_dict.get("food_choices", [])

func timeline_events() -> Array:
	return ("""
join waiter center
waiter: RESTAURANT_0
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	do Game.restaurant.play_buy_sound()
	set {selected_food} = 0
	jump eat/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	do Game.restaurant.play_buy_sound()
	set {selected_food} = 1
	jump eat/
- %s | [if {State.progress.money} >= %s] [else="disabled"]
	do Game.restaurant.play_buy_sound()
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
	date = Global.get_date()
	State.merge_progress({"restaurant": {"date": date, "food_choices": random_choices}})
	return random_choices
	
func start_timeline():
	if Global.get_date() != date:
		food_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func before_eat(is_mouse: bool, idx: int) -> bool: # is_poison
	var food = food_choices[idx]
	if randf() < food_poison_prob():
		if is_mouse:
			Game.update_status({"money": -food.cost}.merged({"bag": {3: -1}, "luck": 10}))
		else:
			Game.update_status({"money": -300-food.cost, "time": 180, "luck": 10, "mood": -5})
		return true
	Game.update_status({"money": -food.cost})
	return false

func eat(idx: int) -> bool: # is_tasty
	var food = food_choices[idx]
	Game.update_status(food.effect)
	if food.is_tasty:
		Global.play_sound(yay_sound if randf() < 0.5 else woo_sound)
	else:
		Global.play_sound(sigh_sound)
	return food.is_tasty

func cry() -> void:
	Global.play_sound(cry_sound)

func play_buy_sound() -> void:
	Global.play_sound(buy_sound)
