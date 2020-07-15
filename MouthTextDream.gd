extends Node2D

var is_Mom_opening = false
var is_Son_opening = false

var MOM_MESSAGE = "This is a test"
var SON_MESSAGE = "This is a test"

func _ready():
	is_Mom_opening = true
	$HBoxContainer/Mom.play("open_mouth")

func _on_Mom_animation_finished():
	if is_Mom_opening:
		$MessageFill.set_message(MOM_MESSAGE)
		$HBoxContainer/Mom/LetterSpawner.show_message(MOM_MESSAGE)
		is_Mom_opening = false
	else:
		is_Son_opening = true
		$HBoxContainer/Son.play("open_mouth")
	
func _on_message_finished():
	yield(get_tree().create_timer(1), "timeout")
	$HBoxContainer/Mom.play("close_mouth")


func _on_Son_animation_finished():
	if is_Son_opening:
		$HBoxContainer/Son/LetterSpawner.show_message(SON_MESSAGE)
		is_Son_opening = false
