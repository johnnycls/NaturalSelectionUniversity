extends Control

func _on_hospital_button_pressed() -> void:
	Game.start_hospital()

func _on_restaurant_button_pressed() -> void:
	Game.start_restaurant()

func _on_home_button_pressed() -> void:
	Game.start_home()

func _on_supermarket_button_pressed() -> void:
	Game.start_supermarket()

func _on_lecture_button_pressed() -> void:
	Game.start_lecture()
