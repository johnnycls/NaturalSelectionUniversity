extends CanvasLayer

var status_bar_content_scene = preload("res://uis/status_bar_content.tscn")

var status_bar_content

func close_menu() -> void:
	status_bar_content.queue_free()
	status_bar_content = null

func open_menu() -> void:
	status_bar_content = status_bar_content_scene.instantiate()
	add_child(status_bar_content)

func update_status(new_status: Dictionary) -> void:
	State.merge_progress(new_status)
	if status_bar_content!=null:
		status_bar_content.update_status(new_status)
