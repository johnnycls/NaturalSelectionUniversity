extends Node

const PROGRESS_PATH = "user://progress.save"
const RECORD_PATH = "user://record.save"
const SETTINGS_PATH = "user://settings.save"
const MISC_PATH = "user://misc.save"

const LANG_IDS_TO_CODES: Dictionary = {0: "cmn", 1: "en", 2: "zh"}
const LANG_NAMES = {"cmn": "简体中文", "en": "English", "zh": "繁體中文"}
const DEFAULT_LANG = 1

const FOOD_NUM = 8
const FOOD_POISON_PROB = 0.3
const PAPER_BAD_PROB = 0.5

var INIT_PROGRESS = {
	"money": 10000, 
	"hunger": 100,
	"paper": 0,
	"hp": 100,
	"spirit": 100,
	"mood": 100,
	"strength": 0,
	"intelligence": 0,
	"luck": 0,
	"inspiration": 0,
	"date": 0,
	"time": 0,
	"bag": {},
}

var MAX_PROGRESS = {
	"hunger": 100,
	"hp": 100,
	"spirit": 100,
	"mood": 100,
	"luck": 100,
	"inspiration": 100,
}
