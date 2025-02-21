extends Control

@onready var hospital_btn = $HospitalButton
@onready var restaurant_btn = $RestaurantButton
@onready var home_btn = $HomeButton
@onready var supermarket_btn = $SupermarketButton
@onready var lecture_btn = $LectureButton

func _ready() -> void:
	hospital_btn.text = tr("HOSPITAL")
	restaurant_btn.text = tr("RESTAURANT")
	home_btn.text = tr("HOME")
	supermarket_btn.text = tr("SUPERMARKET")
	lecture_btn.text = tr("LECTURE_HALL")

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
