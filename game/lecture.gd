class_name Lecture

var sigh_sound = preload("res://assets/audio/sigh.mp3")
var woo_sound = preload("res://assets/audio/woo.mp3")
var yay_sound = preload("res://assets/audio/yay.mp3")

var COURSES = [
	{"name": "COURSE_0", "effect": {"intelligence": 2, "luck": 20, "time": 180, "spirit": -30, "hunger": -30}},
	{"name": "COURSE_1", "effect": {"strength": 5, "hp": -20, "time": 180, "spirit": -40, "hunger": -40}},
	{"name": "COURSE_2", "effect": {"intelligence": 1, "mood": 30, "time": 180, "spirit": -15, "hunger": -30}},
	{"name": "COURSE_3", "effect": {"intelligence": 3, "time": 180, "spirit": -30, "hunger": -30}},
	{"name": "COURSE_4", "effect": {"strength": 3, "time": 180, "spirit": -40, "hunger": -40}},
]
var date: int = -1
var course_choices: Array = []

func init(saved_dict: Dictionary) -> void:
	date = saved_dict.get("date", -1)
	course_choices = saved_dict.get("course_choices", [])
	
func bad_lecture_prob() -> float:
	return (100 - State.progress.get("luck", 0)) / 200
		
func timeline_events() -> Array:
	return ("""[background arg="res://assets/environment_sprites/lecture_hall.jpg" fade="0.0"]
join me center
me: LECTURE_0
- %s
	set {selected_course} = 0
	jump course/
- %s
	set {selected_course} = 1
	jump course/
- LECTURE_1
	leave me
	do Game.back_to_map()""" % [
		course_choices[0].name, course_choices[1].name
	]).split("\n")

func get_random_choices(choices: int) -> Array:
	var all_choices = COURSES.duplicate(true)
	all_choices.shuffle()
	var random_choices = all_choices.slice(0, choices)
	date = Global.get_date()
	State.merge_progress({"lecture": {"date": date, "course_choices": random_choices}})
	return random_choices
	
func start_timeline():
	if Global.get_date() != date:
		course_choices = get_random_choices(2)
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = timeline_events()
	Dialogic.start(timeline)

func attend_lecture(idx: int) -> bool: # good_lecture
	var course = course_choices[idx]
	if randf()<bad_lecture_prob():
		Global.play_sound(sigh_sound)
		var effect = {}
		for key in course.effect:
			effect[key] = course.effect[key] if key in ["time", "hunger", "spirit"] else course.effect[key]/2
		Game.update_status(effect)
		return false
	Global.play_sound(yay_sound if randf() < 0.5 else woo_sound)
	Game.update_status(course.effect)
	return true
