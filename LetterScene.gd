extends Node2D

func set_text(letter):
	$Label.text = letter
	
func spawn():
	$Label/AnimationPlayer.play("FloatUp")