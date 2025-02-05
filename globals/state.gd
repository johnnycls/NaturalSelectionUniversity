extends Node

var progress: Dictionary = {}
var settings: Dictionary = {}
var record: Dictionary = {}

func _ready() -> void:
	settings = _read_json_file(Config.SETTINGS_PATH)
	progress = _read_json_file(Config.PROGRESS_PATH)
	record = _read_json_file(Config.RECORD_PATH)
	_update_lang()

func _read_json_file(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		return {}
	var json = JSON.new()
	return json.get_data() if json.parse(file.get_as_text()) == OK else {}
	
func _save_json_file(path: String, data: Dictionary) -> bool:
	var file = FileAccess.open(path, FileAccess.WRITE)
	if not file:
		return false
	file.store_string(JSON.stringify(data))
	file.close()
	return true

func update_progress(delta: Dictionary) -> void:
	for key in delta:
		progress[key] = progress.get(key, 0) + delta[key]
	save_progress(progress)

func merge_progress(_progress: Dictionary) -> void:
	progress.merge(_progress, true)
	save_progress(progress)

func save_progress(_progress: Dictionary) -> bool:
	return _save_json_file(Config.PROGRESS_PATH, _progress)

func _delete_progress() -> bool:
	return DirAccess.remove_absolute(Config.PROGRESS_PATH) == OK if FileAccess.file_exists(Config.PROGRESS_PATH) else true

func save_settings(_settings) -> bool:
	var file = FileAccess.open(Config.SETTINGS_PATH, FileAccess.WRITE)
	if not file:
		return false
	file.store_var(_settings)
	file.close()
	_update_lang()
	return true

func _read_settings() -> Dictionary:	
	return _read_json_file(Config.SETTINGS_PATH)
	
func _update_lang():
	var lang_id: int = settings.get("language", Config.DEFAULT_LANG)
	TranslationServer.set_locale(Config.LANG_IDS_TO_CODES[lang_id])

func merge_record(_record: Dictionary) -> void:
	record.merge(_record, true)
	save_record(record)

func save_record(_record: Dictionary) -> bool:
	return _save_json_file(Config.RECORD_PATH, _record)

func _delete_record() -> bool:
	return DirAccess.remove_absolute(Config.RECORD_PATH) == OK if FileAccess.file_exists(Config.RECORD_PATH) else true
