class_name Lecture

const BAD_LECTURE_PROB = 0.2

var COURSES = [
	{"name": "COURSE_0", "effect": {"intelligence": 4, "luck": 40, "time": 3, "spirit": -30, "hunger": -30}},
	{"name": "COURSE_1", "effect": {"strength": 12, "hp": -10, "time": 3, "spirit": -40, "hunger": -40}},
	{"name": "COURSE_0", "effect": {"intelligence": 3, "mood": 35, "time": 3, "spirit": -25, "hunger": -25}},
	{"name": "COURSE_3", "effect": {"intelligence": 4, "time": 2, "spirit": -20, "hunger": -20}},
	{"name": "COURSE_4", "effect": {"strength": 8, "time": 2, "spirit": -30, "hunger": -30}},
	{"name": "COURSE_5", "effect": {"intelligence": 4, "mood": 15, "time": 2, "spirit": -20, "hunger": -20}},
]
var date: int = -1
var course_choices: Array = []

func _init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	course_choices = saved_dict.get("course_choices", [])

func timeline_events() -> Array:
	return ("""join me center
me: LECTURE_0
- %s
	set {selected_course} = 0
	jump course/
- %s
	set {selected_course} = 1
	jump course/
- LECTURE_1
	do Game.back_to_map()""" % [
		course_choices[0].name, course_choices[1].name, course_choices[2].name
	]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = COURSES.duplicate(true)
	all_choices.shuffle()
	var random_choices = all_choices.slice(0, choices)
	date = State.progress.date
	State.merge_progress({"lecture": {"date": State.progress.date, "course_choices": random_choices}})
	return random_choices
	
func start_timeline():
	Dialogic.end_timeline()
	if State.progress.date != date:
		course_choices = get_random_choices(2)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func attend_lecture(idx: int) -> bool: # good_lecture
	var course = course_choices[idx]
	if randf()<BAD_LECTURE_PROB:
		Game.update_status(course.effect.map(func(e): return e if ["time", "hunger", "spirit"].has(e) else e/2))
		return false
	Game.update_status(course.effect)
	return true
