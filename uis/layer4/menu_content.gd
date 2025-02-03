extends MarginContainer

@onready var back_btn = $PanelContainer/MarginContainer/VBoxContainer/Btns/BackBtn
	
func _ready() -> void:
	get_tree().paused = true
	back_btn.grab_focus()

func _on_back_btn_pressed() -> void:
	get_tree().paused = false
	queue_free()
	
func _on_home_screen_btn_pressed() -> void:
	get_tree().paused = false
	Main.back_to_home_screen()
	queue_free()
