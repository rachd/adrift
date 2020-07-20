extends Control

signal next_message

var shown_characters = 0
var message_length

func set_text(text):
	$NinePatchRect/Button_Image.visible = false
	$NinePatchRect/MarginContainer/Label.visible_characters = 0
	shown_characters = 0
	message_length = len(text)
	$NinePatchRect/MarginContainer/Label.text = text
	$Timer.start()
	
func clear_text():
	$NinePatchRect/Button_Image.visible = false
	$NinePatchRect/MarginContainer/Label.text = ""
	
func _ready():
	self.connect("next_message", get_node("/root/SailingDay"), "_on_next_message")
	$NinePatchRect/Button_Image.visible = false

func _on_Button_pressed():
	emit_signal("next_message")

func _on_Timer_timeout():
	if shown_characters < message_length:
		shown_characters += 1
		$NinePatchRect/MarginContainer/Label.visible_characters = shown_characters
	if shown_characters == message_length:
		$NinePatchRect/Button_Image.visible = true
	elif shown_characters < message_length:
		$Timer.start()
