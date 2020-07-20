extends Node2D

signal game_ended(did_win)
signal scene_ended

func _ready():
	randomize()
	self.connect("game_ended", get_node("/root/SailingDay"), "_on_game_output")
	self.connect("scene_ended", get_node("/root/SailingDay"), "_start_next_day")

func _on_reached_door():
	emit_signal("game_ended", true)
	emit_signal("scene_ended")
	
func _on_player_hit():
	emit_signal("game_ended", false)
	emit_signal("scene_ended")