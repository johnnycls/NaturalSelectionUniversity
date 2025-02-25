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
	"paper": 0.0,
	"hunger": 100,
	"hp": 100,
	"spirit": 100,
	"mood": 100,
	"luck": 100,
	"strength": 0,
	"intelligence": 0,
	"time": 1440, 
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

var ITEMS = [
	{"id": 0, "name": "ITEM_0", "cost": 15, "effect": {}, "usable": false},
	{"id": 1, "name": "ITEM_1", "cost": 25, "effect": {}, "usable": false},
	{"id": 2, "name": "ITEM_2", "cost": 60, "effect": {}, "usable": false},
	{"id": 3, "name": "ITEM_3", "cost": 40, "effect": {"spirit": 60}, "usable": true},
	{"id": 4, "name": "ITEM_4", "cost": 40, "effect": {}, "usable": false},
	{"id": 5, "name": "ITEM_5", "cost": 40, "effect": {"mood": 65}, "usable": true},
	{"id": 6, "name": "ITEM_6", "cost": 85, "effect": {}, "usable": true},
	{"id": 7, "name": "ITEM_7", "cost": 30, "effect": {}, "usable": false},
	{"id": 8, "name": "ITEM_8", "cost": 400, "effect": {}, "usable": false},
]
