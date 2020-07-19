extends ColorRect

signal fade_out_finished
signal fade_in_finished

func fade_out():
	$AnimationPlayer.play("FadeOut")

func fade_in_dream():
	$AnimationPlayer.play("FadeIn")
	
func fade_in():
	$AnimationPlayer.play("FadeInNewDay")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "FadeOut":
		emit_signal("fade_out_finished")
	else:
		emit_signal("fade_in_finished")
		
func _ready():
	self.connect("fade_out_finished", get_node("/root/SailingDay"), "_fade_out_finished")
	self.connect("fade_in_finished", get_node("/root/SailingDay"), "_fade_in_finished")