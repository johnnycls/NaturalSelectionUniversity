extends Node

var controller

func _ready() -> void:
	randomize()
	controller = get_input_type()

func is_node_valid(node) -> bool:
	return node != null and is_instance_valid(node) and not node.is_queued_for_deletion()
	
func get_valid_nodes_in_group(group_name: String) -> Array:
	return get_tree().get_nodes_in_group(group_name).filter(func(node):
		return is_node_valid(node)
	)

func move_with_tween(object: Node2D, target_pos: Vector2, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(object, "global_position", target_pos, duration)
	# tween.set_trans(Tween.TRANS_CUBIC)
	# tween.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	
func play_sound(audio_player: AudioStreamPlayer, sound: AudioStream = null, should_wait: bool = false):
	if not is_instance_valid(audio_player):
		return
	if sound:
		audio_player.stream = sound
	elif not audio_player.stream:
		return
	audio_player.play()
	if should_wait:
		await audio_player.finished

func wait(duration: float):
	var timer = get_tree().create_timer(duration)
	await timer.timeout

func get_input_type(): # not supporting html5
	var os = OS.get_name()
	var joy_name = Input.get_joy_name(0)

	if joy_name != "":
		if joy_name.find("Nintendo") != -1:
			return "nintendo"
		elif joy_name.find("PlayStation") != -1:
			return "playstation"
		elif joy_name.find("Steam Deck") != -1:
			return "steam_deck"
		else:
			return "joy"
	else:
		if os == "Android" or os == "iOS" or os == "HarmonyOS":
			return "touch_screen"
		else:
			return "mouse_keyboard"

func minutes_to_dddhhmm(minutes: int) -> String:
	var total_hours = minutes / 60
	var days = total_hours / 24
	var hours = total_hours % 24
	var remaining_minutes = minutes % 60	    
	return "%s\n%02d:%02d" % [days, hours, remaining_minutes]

func get_date() -> int:
	var minutes = State.progress.get("time", 0)
	return m2d(minutes)

func m2d(minutes: int) -> int:
	var total_hours = minutes / 60
	var days = total_hours / 24
	return days
