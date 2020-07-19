extends Node2D
onready var tween_out = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var mouth_text_dream = preload("res://MouthTextDream.tscn")
var maze_dream = preload("res://MazeDream.tscn")
var chase_dream = preload("res://ChaseDream.tscn")
var fader = preload("res://Fader.tscn")

var dialog = [
	["It's getting dark soon. I wonder if I'll have another strange dream.", 
	"Ever since the storm knocked me off course, my dreams have been especially vivid.", 
	"Each one seems to require something of me.",
	"Ah well, probably nothing more than a case of the nerves.",
	"I shouldn't worry to much about it and focus more about finding land soon",
	"My supplies won't last forever"],
	["That shadowy figure seems familiar.  Have I dreamed about it before?",
	"But could it be...?",
	"A spirit guide?",
	"Were the elders right that they would come to help me on my journey?",
	"No, that's not possible, they're all just stories to keep the kids happy",
	"Everyone knows they send us out knowing most of us won't come back",
	"They have to keep the island from overpopulating somehow."],
	["Day 3"],
	["Day 4"]
]

var no_fish_dialogs = [["No fish today. That storm must have messed up the currents.", "Hopefully I'll have better luck tomorrow."], ["No bites on my line. Maybe I ran into a trickster spirit."]]
var fish_dialogs = [["A bite! Looks like that storm didn't cause the fish any harm.", "I'll be in good shape to get back on course tomorrow."], ["Lots of fish today. Maybe I do have a guardian spirit"]]

var day = 2
var message_index = 0
var current_text = null
var health = 60
var is_win = false
var fade = null
var did_play_fish_result = false

func _set_next_text():
	var dialog_set = dialog[day]
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text);
	elif day > 0:
		if !did_play_fish_result:
			_fish_result()
	else:
		_fade_out()
	
func _set_fish_message():
	var dialog_set
	if is_win:
		dialog_set = fish_dialogs[day-1]
	else:
		dialog_set = no_fish_dialogs[day-1]
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text)
	else:
		_fade_out()
					
func _ready():
	_set_next_text()
	$HealthBar.set_health(health)
	
func _on_next_message():
	if did_play_fish_result:
		_set_fish_message()
	else:
		_set_next_text()
	
func _fish_result():
	did_play_fish_result = true
	if is_win:
		$fishtextbox.show()
		health += 20
	else:
		$nofishtextbox.show()
		health -= 20
	$HealthBar.set_health(health)
	message_index = 0
	yield(get_tree().create_timer(1), "timeout")
	_set_fish_message()

func _cue_next_scene():
	var next_scene
	if day == 0:
		next_scene = maze_dream.instance()
	elif day == 1:
		next_scene = mouth_text_dream.instance()
	elif day == 2:
		next_scene = chase_dream.instance()
	did_play_fish_result = false
	$fishtextbox.hide()
	$nofishtextbox.hide()
	add_child(next_scene)

func _start_next_day():
	day += 1
	message_index = 0
	_fade_in()
	_set_next_text()
	
func _on_game_output(did_win):
	if did_win:
		is_win = true
	else:
		is_win = false
	
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