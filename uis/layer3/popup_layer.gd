extends CanvasLayer

var page

func popup(_page: Control) -> void:
	if page == null:
		page = _page
		add_child(page)
	
func close_popup() -> void:
	page.queue_free()
	page = null
