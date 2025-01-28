extends VBoxContainer

@onready var new_game_btn: Button = $NewGameBtn
@onready var continue_btn: Button = $ContinueBtn

var settings_scene = load("res://uis/settings.tscn")

func _ready() -> void:
	Main.ui_changed.connect(init)
	init()

func init():
	if State.progress.is_empty():
		new_game_btn.grab_focus()
		continue_btn.disabled = true
	else:
		continue_btn.disabled = false
		continue_btn.grab_focus()

func _on_settings_btn_pressed() -> void:
	Main.change_ui(settings_scene.instantiate())

func _on_new_game_btn_pressed() -> void:
	State.save_progress({})
	Main.start_game()

func _on_continue_btn_pressed() -> void:
	Main.start_game()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
