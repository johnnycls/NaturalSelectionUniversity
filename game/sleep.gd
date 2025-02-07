class_name Sleep

func sleep(sleeping_pill: bool) -> bool:
	if sleeping_pill:
		Game.update_status({"spirit": 50, "hp": 25, "time": 8, "bag": {4: -1}})
		return true
	if randf()*100 < State.progress.mood:
		Game.update_status({"spirit": 50, "hp": 25, "time": 8})
		return true
	Game.update_status({"spirit": 20, "hp": 15, "time": 8})
	return false
