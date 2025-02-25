class_name Paper

var sigh_sound = preload("res://assets/audio/sigh.mp3")
var woo_sound = preload("res://assets/audio/woo.mp3")
var yay_sound = preload("res://assets/audio/yay.mp3")

func bad_paper_prob() -> float:
	return (100 - State.progress.get("luck", 0)) / 200

func write_paper() -> bool:
	if randf()<bad_paper_prob():
		Game.update_status({
			"time": 180, 
			"spirit": -25,
			"hunger": -20, 
			"mood": -5,
			"paper": 100 + (State.progress.mood * State.progress.intelligence / 200),
		})
		Global.play_sound(sigh_sound)
		return false
	Game.update_status({
		"time": 180, 
		"spirit": -20, 
		"hunger": -25, 
		"paper": 200 + (State.progress.mood * State.progress.intelligence / 100)
	})
	Global.play_sound(yay_sound if randf() < 0.5 else woo_sound)
	return true
