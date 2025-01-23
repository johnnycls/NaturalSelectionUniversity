extends Node2D

var scene

var current_game_state

func change_scene(_scene):
	if Global.is_node_valid(scene):
		scene.queue_free()
	scene = _scene.instantiate()
	add_child.call_deferred(scene)
	
func init(_state) -> void:
	current_game_state = _state
