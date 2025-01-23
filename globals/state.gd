extends Node

var progress: Dictionary
var settings: Dictionary

func _ready() -> void:
	settings = read_settings()
	update_lang()
	progress = read_progress()

func update_progress(key: String, value)-> void:	
	progress[key] = value
	save_progress(progress)

func read_progress() -> Dictionary:
	if not FileAccess.file_exists(Config.PROGRESS_PATH):
		return {}
	
	var file = FileAccess.open(Config.PROGRESS_PATH, FileAccess.READ)
	if not file:
		return {}
	
	var json = JSON.new()
	return json.get_data() if json.parse(file.get_as_text()) == OK else {}

func save_progress(_progress: Dictionary) -> bool:
	var file = FileAccess.open(Config.PROGRESS_PATH, FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(_progress))
	file.close()
	return true

func delete_progress() -> bool:
	if FileAccess.file_exists(Config.PROGRESS_PATH):
		return DirAccess.remove_absolute(Config.PROGRESS_PATH) == OK
	return true

func save_settings(_settings) -> bool:
	var file = FileAccess.open(Config.SETTINGS_PATH, FileAccess.WRITE)
	if not file:
		return false
	file.store_var(_settings)
	file.close()
	update_lang()
	return true

func read_settings() -> Dictionary:	
	if FileAccess.file_exists(Config.SETTINGS_PATH):
		var file: FileAccess = FileAccess.open(Config.SETTINGS_PATH, FileAccess.READ)
		var _settings = file.get_var()
		file.close()
		return _settings
	return {}
	
func update_lang():
	var lang_id: int = settings.get("language", Config.DEFAULT_LANG)
	TranslationServer.set_locale(Config.LANG_IDS_TO_CODES[lang_id])
