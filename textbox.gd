extends Control

signal next_message

func set_text(text):
	$NinePatchRect/MarginContainer/Label.text = text
	$NinePatchRect/MarginContainer/Label/AnimationPlayer.play("PercentVisible")
	
func _ready():
	self.connect("next_message", get_node("/root/SailingDay"), "_on_next_message")
	$NinePatchRect/Button_Image.visible = false

func _on_Button_pressed():
	emit_signal("next_message")


func _on_AnimationPlayer_animation_finished(anim_name):
	$NinePatchRect/Button_Image.visible = true
