extends Control

signal next_message

func set_text(text):
	$NinePatchRect/MarginContainer/Label.text = text
	
func _ready():
	$NinePatchRect/Button_Image.visible = false
	self.connect("next_message", get_tree().get_root().find_node("SailingDay"), "_on_next_message")

func _on_Button_pressed():
	emit_signal("next_message")


func _on_AnimationPlayer_animation_finished(anim_name):
	$NinePatchRect/Button_Image.visible = true
