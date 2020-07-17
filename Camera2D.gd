extends Camera2D

onready var target = get_node("/root/MazeDream/MazePlayer")

func _process(delta):
	position = target.position