extends Control

signal next_message

func set_text(text):
	$NinePatchRect/Button_Image.visible = false
	$NinePatchRect/MarginContainer/Label.percent_visible = 0
	$NinePatchRect/MarginContainer/Label.text = text
	$NinePatchRect/MarginContainer/Label/AnimationPlayer.play("PercentVisible")
	
func clear_text():
	$NinePatchRect/Button_Image.visible = false
	$NinePatchRect/MarginContainer/Label.text = ""
	
func _ready():
	self.connect("next_message", get_node("/root/SailingDay"), "_on_next_message")
	$NinePatchRect/Button_Image.visible = false

func _on_Button_pressed():
	emit_signal("next_message")


func _on_AnimationPlayer_animation_finished(anim_name):
	$NinePatchRect/Button_Image.visible = true
