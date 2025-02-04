extends Node2D

var map_scene = preload("res://uis/layer1/map.tscn")
	
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if not State.progress.get("is_intro_finished", false):
		Dialogic.start("intro")
	elif not State.progress.get("is_ceremony_finished", false):
		Dialogic.start("ceremony")
	else:
		Main.change_ui(map_scene.instantiate())

func _on_dialogic_signal(argument:Dictionary):
	match argument.get("endpoint", ""):
		"update_status":
			var body = JSON.parse_string(argument.get("body", {}))
			if not body.is_empty():
				Main.update_status(body)
		"back_to_map":
			Dialogic.end_timeline()
			Main.change_ui(map_scene.instantiate())
		var endpoint:
			print("invalid endpoint: " + endpoint)
	
