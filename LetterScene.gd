extends Node2D

func set_text(letter, is_correct):
	if is_correct:
		$Label.set("custom_colors/font_color", Color(1,1,1))
	else:
		$Label.set("custom_colors/font_color", Color(0,0,0))
	$Label.text = letter
	
func spawn(left_path):
	if left_path:
		$Label/AnimationPlayer.play("FloatLeft")
	else:
		$Label/AnimationPlayer.play("FloatRight")