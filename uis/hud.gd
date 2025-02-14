extends Node

var select_sound = preload("res://assets/audio/select.mp3")

@onready var ui: CanvasLayer = $UILayer
@onready var status_bar: CanvasLayer = $StatusBar
@onready var popup_layer: CanvasLayer = $PopupLayer
@onready var menu: CanvasLayer = $Menu
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func select() -> void:
	Global.play_sound(audio_player, select_sound)

func _ready() -> void:
	add_sound_effects_for_btns(ui)
	add_sound_effects_for_btns(menu)
	
func add_sound_effects_for_btns(node: Node) -> void:
	if node is Button:
		node.mouse_entered.connect(select)
		node.focus_entered.connect(select)
		node.button_down.connect(select)
	for child in node.get_children():
		add_sound_effects_for_btns(child)
		
func clear_ui() -> void:
	for n in ui.get_children():
		n.queue_free()

func change_ui(page: Control) -> void:
	clear_ui()
	ui.add_child(page)
	add_sound_effects_for_btns(page)
	
func show_status_bar() -> void:
	status_bar.open()
	
func hide_status_bar() -> void:
	status_bar.close()

func popup(page: Control) -> void:
	popup_layer.popup(page)
	
func close_popup() -> void:
	popup_layer.close()

func open_menu() -> void:
	menu.open_menu()
	
func close_menu() -> void:
	menu.close_menu()
