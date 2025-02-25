class_name Hospital

var buy_sound = preload("res://assets/audio/buy.mp3")
var woo_sound = preload("res://assets/audio/woo.mp3")
var yay_sound = preload("res://assets/audio/yay.mp3")

const CHICKEN_BLOOD_PROB = 0.1

func liver_buy_price() -> int:
	return 100
func liver_sell_price() -> int:
	return 75
func blood_buy_price() -> int:
	return 100
func blood_sell_price() -> int:
	return 75
	
func buy_liver() -> void:
	Global.play_sound(buy_sound)
	Game.update_status({"spirit": 100, "money": -liver_buy_price(), "time": 60})
func sell_liver() -> void:
	Global.play_sound(buy_sound)
	Game.update_status({"spirit": -50, "money": liver_sell_price(), "time": 60})
func buy_blood(is_chicken: bool) -> void:
	Global.play_sound(buy_sound)
	if is_chicken:
		Global.play_sound(yay_sound if randf() < 0.5 else woo_sound)
		Game.update_status({"hp": 100, "money": -blood_buy_price(), "strength": 8, "mood": 50, "luck": -10, "time": 60})
	else:
		Game.update_status({"hp": 100, "money": -blood_buy_price(), "time": 60})
func sell_blood() -> void:
	Global.play_sound(buy_sound)
	Game.update_status({"hp": -50, "money": blood_sell_price(), "time": 60})
