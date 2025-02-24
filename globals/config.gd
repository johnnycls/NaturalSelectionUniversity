extends Node

const PROGRESS_PATH = "user://progress.save"
const RECORD_PATH = "user://record.save"
const SETTINGS_PATH = "user://settings.save"

const LANG_IDS_TO_CODES: Dictionary = {0: "cmn", 1: "en", 2: "zh"}
const LANG_NAMES = {"cmn": "简体中文", "en": "English", "zh": "繁體中文"}
const DEFAULT_LANG = 1

const BAG_VOLUME = 8
const TOTAL_DAYS = 100

var INIT_PROGRESS = {
	"is_intro_finished": false,
	"is_ceremony_finished": false,
	"money": 10000, 
	"paper": 0,
	"hunger": 100,
	"hp": 100,
	"spirit": 100,
	"mood": 100,
	"luck": 100,
	"strength": 0,
	"intelligence": 0,
	"time": 0, 
	"bag": [],
	"supermarket": {},
	"lecture": {},
	"restaurant": {},
	"go_out": {}
}

var MAX_PROGRESS = {
	"hunger": 100,
	"hp": 100,
	"spirit": 100,
	"mood": 100,
	"luck": 100,
}
