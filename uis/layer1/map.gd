extends Control

func _on_hospital_pressed() -> void:
	Dialogic.start("hospital")
	Main.clear_ui()
	
func _on_restaurant_pressed() -> void:
	Game.restaurant.start_timeline()
	Main.clear_ui()
	
func _on_home_pressed() -> void:
	Dialogic.start("home")
	Main.clear_ui()
	
func _on_supermarket_pressed() -> void:
	Game.supermarket.start_timeline()
	Main.clear_ui()
	
func _on_lecture_pressed() -> void:
	Game.lecture.start_timeline()
	Main.clear_ui()
