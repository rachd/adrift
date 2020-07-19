extends Node2D

var mouth_text_dream = preload("res://MouthTextDream.tscn")
var maze_dream = preload("res://MazeDream.tscn")
var chase_dream = preload("res://ChaseDream.tscn")
var fader = preload("res://Fader.tscn")

var dialog = [
	["It's getting dark soon. I wonder if I'll have another strange dream.", 
	"Ever since the storm knocked me off course, my dreams have been especially vivid.", 
	"Each one seems to require something of me.",
	"Ah well, probably nothing more than a case of the nerves.",
	"I shouldn't worry too much about it and focus more about finding land soon.",
	"My supplies have gotten low."],
	["That shadowy figure seems familiar.  Have I dreamed about it before?",
	"But could it be...? A spirit guide?",
	"Were the elders right that they would come to help me on my journey?",
	"No, that's not possible, they're all just stories to keep the kids happy",
	"Everyone knows they send us out knowing most of us won't come back",
	"They have to keep the island from overpopulating somehow."],
	["Why do I keep having these dreams?", "Am I being sent a message?", "No, I must be going crazy. Too much time out in the sun."],
	["Day 4"]
]

var no_fish_dialogs = [["No fish today. That storm must have messed up the currents.", "Hopefully I'll have better luck tomorrow."], ["No bites on my line. Maybe I ran into a trickster spirit."], ["No fish 3"]]
var fish_dialogs = [["A bite! Looks like that storm didn't cause the fish any harm.", "I'll be in good shape to get back on course tomorrow."], ["Lots of fish today. Maybe I do have a guardian spirit"], ["This will keep me going for a while!"]]
var death_dialog = ["All this time with no food... I lack the strength to go on...", "Looks like I won't get to see my mother again.", "They'll say I died because I wasn't a true believer.", "I hope she knows I love her."]
var life_dialog = ["Whether it is madness or mysticism, my fate seems tied to these dreams.", "If I can master them, maybe I can return home.", "Or maybe I am just the plaything of some bored spirit", "only keeping me alive until its amusement fades.", "Either way, I have no choice but to sail on."]

var day = 0
var message_index = 0
var current_text = null
var health = 50
var is_win = false
var fade = null
var did_play_fish_result = false
var is_game_over = false

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
	elif day == 3:
		message_index = 0
		_live()
	else:
		_fade_out()
					
func _ready():
	_set_next_text()
	$HealthBar.set_health(health)
	
func _on_next_message():
	if is_game_over:
		if health == 0:
			_die()
		else:
			_live()
	elif did_play_fish_result:
		_set_fish_message()
	else:
		_set_next_text()
	
func _fish_result():
	$textbox.clear_text()
	yield(get_tree().create_timer(2), "timeout")
	did_play_fish_result = true
	if is_win:
		$fishtextbox.show()
		health += 20
	else:
		$nofishtextbox.show()
		health -= 20
	$HealthBar.set_health(health)
	yield(get_tree().create_timer(1), "timeout")
	message_index = 0
	if health == 0:
		_die()
	else:
		yield(get_tree().create_timer(1), "timeout")
		_set_fish_message()

func _live():
	var dialog_set = life_dialog
	is_game_over = true
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text)
	else:
		_fade_out()
	
func _die():
	var dialog_set = death_dialog
	is_game_over = true
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text)
	else:
		_fade_out()
		
func _cue_next_scene():
	if is_game_over:
		get_tree().change_scene("res://TitleScreen.tscn")
		
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
	$textbox.clear_text()
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
	
func _fade_in():
	_add_fader()
	fade.fade_in()
	
func _fade_in_finished():
	$AudioStreamPlayer.play()
	fade.queue_free()

func _fade_out_finished():
	$AudioStreamPlayer.stop()
	_cue_next_scene()
	fade.queue_free()