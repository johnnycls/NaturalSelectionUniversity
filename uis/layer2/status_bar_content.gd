extends MarginContainer

@onready var hp_bar = $VBoxContainer/TopBar/HP/ProgressBar
@onready var hunger_bar = $VBoxContainer/TopBar/Hunger/ProgressBar
@onready var paper_bar = $VBoxContainer/TopBar/Paper/Control/ProgressBar
@onready var paper_label = $VBoxContainer/TopBar/Paper/Control/Label
@onready var spirit_bar = $VBoxContainer/TopBar/Spirit/ProgressBar
@onready var mood_bar = $VBoxContainer/TopBar/Mood/ProgressBar
@onready var luck_bar = $VBoxContainer/TopBar/Luck/ProgressBar
@onready var money_label = $VBoxContainer/TopBar/Money/MarginContainer/Label
@onready var datetime_label = $VBoxContainer/TopBar/DateTime/Label
@onready var strength_label = $VBoxContainer/HBoxContainer/RightBar/Strength/VBoxContainer/Label
@onready var intelligence_label = $VBoxContainer/HBoxContainer/RightBar/Intelligence/VBoxContainer/Label
@onready var left_bar = $VBoxContainer/HBoxContainer/LeftBar

var item_button_scene = preload("res://uis/layer2/item_button.tscn")

func update_status() -> void:
	hp_bar.value = State.progress.get("hp", 0)
	hunger_bar.value = State.progress.get("hunger", 0)
	paper_bar.value = State.progress.get("paper", 0.0)
	paper_label.text = "%.1f%%" % (State.progress.get("paper", 0.0)/1000.0)
	spirit_bar.value = State.progress.get("spirit", 0)
	mood_bar.value = State.progress.get("mood", 0)
	luck_bar.value = State.progress.get("luck", 0)
	money_label.text = str(State.progress.get("money", 0))
	datetime_label.text = Global.minutes_to_dddhhmm(State.progress.get("time", 0))
	strength_label.text = str(State.progress.get("strength", 0))
	intelligence_label.text = str(State.progress.get("intelligence", 0))
	
	for n in left_bar.get_children():
		n.queue_free()
	for idx in range(State.progress.get("bag", []).size()):
		var item_button = item_button_scene.instantiate()
		left_bar.add_child(item_button)
		item_button.init(State.progress.bag[idx], idx)

func _on_pause_button_pressed() -> void:
	Main.open_menu()
