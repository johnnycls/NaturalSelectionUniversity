class_name Lecture

const BAD_LECTURE_PROB = 0.2

var COURSES = [
	{"name": "COURSE_0", "effect": {}},
	{"name": "COURSE_1", "effect": {}},
	{"name": "COURSE_2", "effect": {}},
	{"name": "COURSE_3", "effect": {}},
	{"name": "COURSE_4", "effect": {}},
	{"name": "COURSE_5", "effect": {}},
	{"name": "COURSE_6", "effect": {}},
]
var date: int = -1
var course_choices: Array = []

func timeline_events() -> Array:
	return ("""join me center
me: LECTURE_0
- %s
	set {selected_course} = 0
	jump course/
- %s
	set {selected_course} = 1
	jump course/
- %s
	set {selected_course} = 2
	jump course/
- LECTURE_1
	do Game.back_to_map()""" % [
		course_choices[0].name, course_choices[1].name, course_choices[2].name
	]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = COURSES.duplicate(true)
	all_choices.shuffle()
	return all_choices.slice(0, choices)
	
func start_timeline():
	if State.progress.date != date:
		course_choices = get_random_choices(3)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func attend_lecture(idx: int) -> bool: # good_lecture
	var course = course_choices[idx]
	Game.update_status(course.effect)
	return true
