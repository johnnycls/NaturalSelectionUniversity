class_name Sleep

var sigh_sound = preload("res://assets/audio/sigh.mp3")
var woo_sound = preload("res://assets/audio/woo.mp3")
var yay_sound = preload("res://assets/audio/yay.mp3")

func sleep(sleeping_pill: bool) -> bool:
	if sleeping_pill:
		var new_bag = Game.remove_bag_item(4)
		Game.update_status({"spirit": 50, "hp": 25, "time": 480, "bag": new_bag, "hunger": -10})
		return true
	if randf()*100 < State.progress.mood:
		Game.update_status({"spirit": 50, "hp": 25, "time": 480, "hunger": -10, "mood": 10})
		Global.play_sound(yay_sound if randf() < 0.5 else woo_sound)
		return true
	Game.update_status({"spirit": 20, "hp": 15, "time": 480, "hunger": -10, "mood": -10})
	Global.play_sound(sigh_sound)
	return false
