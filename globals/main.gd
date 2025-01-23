extends Node

signal ui_changed

var home_scene = load("res://uis/home.tscn")
var game_scene = load("res://game/index.tscn")
var levels_ui = load("res://uis/levels.tscn")

@onready var hud = $Hud

var _current_scene: Node
var can_open_menu: bool = false
var is_dialogue: bool = false
	
func _remove_scene() -> void:
	if Global.is_node_valid(_current_scene):
		_current_scene.queue_free()
		_current_scene = null
	
func start_game() -> void:
	_remove_scene()
	hud.clear_ui()
	_current_scene = game_scene.instantiate()
	add_child.call_deferred(_current_scene)
	can_open_menu = true

func back_to_home_screen() -> void:
	_remove_scene()
	change_ui(home_scene.instantiate())
	can_open_menu = false
	BgmPlayer.play_bgm(0,0)

func change_ui(page: Control) -> void:
	hud.change_ui(page)
	ui_changed.emit()

func open_menu() -> void:
	hud.open_menu()
	
func close_menu() -> void:
	hud.close_menu()
