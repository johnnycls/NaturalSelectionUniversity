extends CanvasLayer

var menu_content_scene = preload("res://uis/menu_content.tscn")

var menu_content
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		if menu_content!=null:
			close_menu()
		elif (Main.can_open_menu):
			open_menu()

func close_menu() -> void:
	menu_content.queue_free()
	menu_content = null

func open_menu() -> void:
	menu_content = menu_content_scene.instantiate()
	add_child(menu_content)
