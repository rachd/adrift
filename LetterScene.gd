extends Node2D

func set_text(letter):
	$Label.text = letter
	
func spawn(left_path):
	if left_path:
		$Label/AnimationPlayer.play("FloatLeft")
	else:
		$Label/AnimationPlayer.play("FloatRight")