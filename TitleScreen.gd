extends Control

onready var tween_in = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

func _ready():
	tween_in.interpolate_property($AudioStreamPlayer, "volume_db", -80, -20, transition_duration, transition_type, Tween.EASE_IN, 0)
	tween_in.start()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://SailingDay.tscn")
