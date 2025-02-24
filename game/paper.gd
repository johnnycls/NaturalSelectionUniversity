class_name Paper

var BAD_PAPER_PROB = 0.25

func write_paper() -> bool:
	if randf()<BAD_PAPER_PROB:
		Game.update_status({
			"time": 180, 
			"spirit": -40,
			"hunger": -30, 
			"paper": 0.1 + State.progress.mood * State.progress.spirit * State.progress.intelligence / 2000000
		})
		return false
	Game.update_status({
		"time": 180, 
		"spirit": -30, 
		"hunger": -40, 
			"paper": 0.2 + State.progress.mood * State.progress.spirit * State.progress.intelligence / 1000000
	})
	return true
