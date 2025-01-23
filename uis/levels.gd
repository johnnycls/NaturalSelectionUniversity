extends MarginContainer

var home_ui = load("res://uis/home.tscn")

var UNLOCK_CRITERIA = {
	0: true,
}

func _ready():
	Main.ui_changed.connect(init)

func init():
	pass
	#last_unlocked_button.grab_focus()

func start_level(level: int)-> void:
	Main.start_level(level)

func _on_back_btn_pressed() -> void:
	Main.change_ui(home_ui.instantiate())
