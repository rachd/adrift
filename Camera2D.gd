extends Camera2D

onready var target = get_node("/root/SailingDay/MazeDream/MazePlayer")

func _process(delta):
	position = target.position