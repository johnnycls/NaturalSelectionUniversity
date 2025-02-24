extends TextureButton

func init(item_id: int) -> void:
	disabled = not Config.ITEMS[item_id].usable

func _on_pressed() -> void:
	pass # Replace with function body.
