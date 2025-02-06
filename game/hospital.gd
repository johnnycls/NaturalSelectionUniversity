class_name Hospital

const CHICKEN_BLOOD_PROB = 0.2

func liver_buy_price() -> float:
	return 200.0
func liver_sell_price() -> float:
	return 100.0
func blood_buy_price() -> float:
	return 200.0
func blood_sell_price() -> float:
	return 100.0
	
func buy_liver() -> void:
	Game.update_status({"spirit": 100, "money": -liver_buy_price()})
func sell_liver() -> void:
	Game.update_status({"spirit": -50, "money": liver_sell_price()})
func buy_blood(is_chicken: bool) -> void:
	if is_chicken:
		Game.update_status({"spirit": 100, "money": -blood_buy_price(), "strength": 10})
	else:
		Game.update_status({"spirit": 100, "money": -blood_buy_price()})
func sell_blood() -> void:
	Game.update_status({"spirit": -50, "money": blood_sell_price()})
