class_name Paper

var BAD_PAPER_PROB = 0.25

func write_paper() -> bool:
	if randf()<BAD_PAPER_PROB:
		Game.update_status({
			"time": 3, 
			"spirit": -40,
			"hunger": -30, 
			"paper": 0.1 + 0.002*State.progress.mood + 0.002*State.progress.spirit + 0.002*State.progress.intelligence
		})
		return false
	Game.update_status({
		"time": 3, 
		"spirit": -30, 
		"hunger": -40, 
		"paper": 0.2 + 0.003*State.progress.mood + 0.003*State.progress.spirit + 0.004*State.progress.intelligence
	})
	return true
