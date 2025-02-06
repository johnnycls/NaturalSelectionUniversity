class_name Sleep

func sleep() -> bool:
	if randf()*100 < State.progress.mood:
		Game.update_status({"spirit": 50, "hp": 25, "time": 8})
		return true
	Game.update_status({"spirit": 20, "hp": 15, "time": 8})
	return false
