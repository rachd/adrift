extends Camera2D

onready var target = get_node("/root/SailingDay/ChaseDream/ChasePlayer")

func _process(delta):
	position = target.position + Vector2(-50, 0)