class_name Paper

func bad_paper_prob() -> float:
	return (100 - State.progress.get("luck", 0)) / 200

func write_paper() -> bool:
	if randf()<bad_paper_prob():
		Game.update_status({
			"time": 180, 
			"spirit": -25,
			"hunger": -20, 
			"paper": 10 + (State.progress.mood * State.progress.intelligence / 2000)
		})
		return false
	Game.update_status({
		"time": 180, 
		"spirit": -20, 
		"hunger": -25, 
		"paper": 20 + (State.progress.mood * State.progress.intelligence / 1000)
	})
	return true
