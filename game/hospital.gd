class_name Hospital

const CHICKEN_BLOOD_PROB = 0.2

func liver_buy_price() -> int:
	return 100
func liver_sell_price() -> int:
	return 75
func blood_buy_price() -> int:
	return 100
func blood_sell_price() -> int:
	return 75
	
func buy_liver() -> void:
	Game.update_status({"spirit": 100, "money": -liver_buy_price(), "time": 1})
func sell_liver() -> void:
	Game.update_status({"spirit": -50, "money": liver_sell_price(), "time": 1})
func buy_blood(is_chicken: bool) -> void:
	if is_chicken:
		Game.update_status({"spirit": 100, "money": -blood_buy_price(), "strength": 10, "time": 60})
	else:
		Game.update_status({"spirit": 100, "money": -blood_buy_price(), "time": 60})
func sell_blood() -> void:
	Game.update_status({"spirit": -50, "money": blood_sell_price(), "time": 60})
