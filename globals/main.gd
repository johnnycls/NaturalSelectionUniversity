extends Node

signal ui_changed

var home_scene = load("res://uis/layer1/home.tscn")

@onready var hud = $Hud

var can_open_menu: bool = false

func clear_ui() -> void:
	hud.clear_ui()

func start_game() -> void:
	hud.clear_ui()
	Game.start_game()
	can_open_menu = true

func back_to_home_screen() -> void:
	Game.end_game()
	change_ui(home_scene.instantiate())
	BgmPlayer.play_bgm(0,0)
	can_open_menu = false

func change_ui(page: Control) -> void:
	hud.change_ui(page)
	ui_changed.emit()

func open_menu() -> void:
	hud.open_menu()
	
func close_menu() -> void:
	hud.close_menu()
