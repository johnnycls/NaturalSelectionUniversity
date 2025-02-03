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
	match argument.endpoint:
		"intro_ended":
			State.merge_progress({"is_intro_finished": true})
			Dialogic.start("ceremony")
		"ceremony_ended":
			State.merge_progress({"is_ceremony_finished": true})
		"update_status":
			Main.update_status(argument.body)
		"back_to_map":
			Main.change_ui(map_scene.instantiate())
		var endpoint:
			print(endpoint)
	
