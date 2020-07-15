extends Node2D

var is_Mom_opening = false
var is_Son_opening = false

func _ready():
	is_Mom_opening = true
	$HBoxContainer/Mom.play("open_mouth")

func _on_Mom_animation_finished():
	if is_Mom_opening:
		$HBoxContainer/Mom/LetterSpawner.show_message("This is a test")
		is_Mom_opening = false
	else:
		is_Son_opening = true
		$HBoxContainer/Son.play("open_mouth")
	
func _on_message_finished():
	yield(get_tree().create_timer(1), "timeout")
	$HBoxContainer/Mom.play("close_mouth")


func _on_Son_animation_finished():
	if is_Son_opening:
		$HBoxContainer/Son/LetterSpawner.show_message("This is a test")
		is_Son_opening = false
