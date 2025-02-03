extends Node2D
	
func _ready() -> void:
	Dialogic.signal_event.connect(_on_dialogic_signal)
	
	if not State.progress.get("is_intro_finished", false):
		Dialogic.start("intro")
	elif not State.progress.get("is_ceremony_finished", false):
		Dialogic.start("ceremony")
	else:
		pass

func _on_dialogic_signal(argument:Dictionary):
	if argument.title == "intro_ended":
		State.merge_progress({"is_intro_finished": true})
		Dialogic.start("ceremony")
		
	elif argument.title == "ceremony_ended":
		State.merge_progress({"is_ceremony_finished": true})
