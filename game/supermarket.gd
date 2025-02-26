class_name Supermarket

var buy_sound = preload("res://assets/audio/buy.mp3")

var date: int = -1
var item_choices: Array = []

func init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	item_choices = saved_dict.get("item_choices", [])

func timeline_events() -> Array:
	return ("""[background arg="res://assets/environment_sprites/supermarket.png" fade="0.0"]
join sales center
sales: SUPERMARKET_0
label choice
- %s | [if State.progress.money >= %s and not Game.is_bag_full()] [else="disable"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(0)
	sales: SUPERMARKET_4
	jump choice
- %s | [if State.progress.money >= %s and not Game.is_bag_full()] [else="disable"]
	sales: SUPERMARKET_2
	do Game.supermarket.buy_item(1)
	sales: SUPERMARKET_4
	jump choice
- SUPERMARKET_1
	sales: SUPERMARKET_3
	leave sales
	leave me
	do Game.back_to_map()""" % [
	"%s: $%s" % [tr(item_choices[0].name), item_choices[0].cost], item_choices[0].cost,
	"%s: $%s" % [tr(item_choices[1].name), item_choices[1].cost], item_choices[1].cost, 
]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = Config.ITEMS.duplicate(true)
	all_choices.shuffle()
	var random_choices = all_choices.slice(0, choices)
	date = Global.get_date()
	State.merge_progress({"supermarket": {"date": date, "item_choices": random_choices}})
	return random_choices
	
func start_timeline():
	if Global.get_date() != date:
		item_choices = get_random_choices(2)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func buy_item(idx: int):
	Global.play_sound(buy_sound)
	var item = item_choices[idx]
	Game.update_status({"money": -item.cost, "bag": State.progress.get("bag", []) + [item.id]})
