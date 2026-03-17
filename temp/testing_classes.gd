extends Control

var test_lesson = Lesson.new(
	"test_lesson",
	"Test rules!",
	(func(): print("win con"); return false),
	(func(): print("can drop"); return false),
	(func(): print("drop data"); return false),
	(func(): print("min moves"); return 1),
	[Function.new(
			"test func", 
			Function.Type.LOWER_ORDER,
			(func(): print("test f"); return 2),
			false
	)]
)

func _ready() -> void:
	load_lesson(test_lesson)

func load_lesson(lesson: Lesson):
	print(lesson.name)
	print(lesson.rules)
	print(lesson.check_win_con())
