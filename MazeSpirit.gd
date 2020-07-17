extends Area2D

signal found_spirit

func _on_MazeSpirit_body_entered(body):
	print(body.name)
	if body.name == "MazePlayer":
		print("found_spirit_in_mazespirit_script")
		emit_signal("found_spirit")

func _ready():
	self.connect("found_spirit", get_node("/root/SailingDay/MazeDream"), "_on_found_spirit")
