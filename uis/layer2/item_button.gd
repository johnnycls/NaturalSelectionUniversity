extends Button

var item
var idx

func init(_item_id: int, _idx: int) -> void:
	idx = _idx
	item = Config.ITEMS.filter(func(i): return i.id==_item_id)[0]
	disabled = not item.usable
	icon = item.img

func use_item() -> void:
	var original_bag = State.progress.get("bag", [])
	if item.id==6:
		var new_bag = original_bag.duplicate(true)
		new_bag.remove_at(idx)
		State.merge_progress({"hp": randi_range(5,100), "hunger": randi_range(5,100), "spirit": randi_range(5,100), "mood": randi_range(5,100), "bag": new_bag})
	else:
		var new_bag = State.progress.get("bag", []).duplicate(true).map(func(n): return int(n))
		new_bag.remove_at(idx)
		Game.update_status(item.effect.merged({"bag": new_bag}))

func _on_pressed():
	use_item()
