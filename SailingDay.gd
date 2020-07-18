extends Node2D
onready var tween_out = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var mouth_text_dream = preload("res://MouthTextDream.tscn")
var maze_dream = preload("res://MazeDream.tscn")
var fader = preload("res://Fader.tscn")

var dialog = [
	["This is the first text.  It should set the scene.", 
	"This is the second text.  It should tell more about the character.", 
	"This is the third text.  More story development and generally interesting content."],
	["Second day first text."]
]

var day = 0
var message_index = 0
var current_text = null
var health = 60
var is_win = false
var fade = null

func _set_next_text():
	var dialog_set = dialog[day]
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text);
	else:
		_fade_out()
	

func _ready():
	_set_next_text();
	$HealthBar.set_health(health)
	
func _on_next_message():
	_set_next_text()

func _cue_next_scene():
	var next_scene
	if day == 0:
		next_scene = maze_dream.instance()
	elif day == 1:
		next_scene = mouth_text_dream.instance()
	add_child(next_scene)
	

func _start_next_day():
	day += 1
	message_index = 0
	_fade_in()
	_set_next_text()
	
func _on_game_output(did_win):
	if did_win:
		health += 20
		is_win = true
	else:
		health -= 20
		is_win = false
	$HealthBar.set_health(health)
	
func _add_fader():
	fade = fader.instance()
	fade.rect_size.x = 1024
	fade.rect_size.y = 600
	add_child(fade)

func _fade_out():
	_add_fader()
	fade.fade_out()
	# tween music volume down to 0
	#tween_out.interpolate_property($AudioStreamPlayer, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	#tween_out.start()
	
func _fade_in():
	_add_fader()
	fade.fade_in()
	#tween_out.interpolate_property($AudioStreamPlayer, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	#tween_out.start()
	
func _fade_in_finished():
	$AudioStreamPlayer.play()
	fade.queue_free()

func _fade_out_finished():
	$AudioStreamPlayer.stop()
	_cue_next_scene()
	fade.queue_free()