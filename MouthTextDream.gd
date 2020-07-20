extends Node2D

signal game_ended(did_win)
signal scene_ended

var is_Mom_opening = false
var current_mom_message = 0
var is_Son_opening = false
var time_remaining = 25
var is_Mom_talking = false
var is_Son_talking = false
var did_mom_already_talk = false

var did_win = false

var MOM_MESSAGES = ["I miss my son terribly.", "If only he would speak to me."]
var MOM_SECOND_MESSAGES = ["Where are you son?", "I can't hear you."]
var RANDOM_STRING_LENGTH = 30
var ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

var rng = RandomNumberGenerator.new()

func _ready():
	self.connect("game_ended", get_node("/root/SailingDay"), "_on_game_output")
	self.connect("scene_ended", get_node("/root/SailingDay"), "_start_next_day")
	rng.randomize()
	is_Mom_opening = true
	is_Mom_talking = true
	$HBoxContainer/Mom.play("open_mouth")

func _on_Mom_animation_finished():
	if is_Mom_opening:
		_play_mom_message()
		is_Mom_opening = false
	else:
		is_Mom_talking = false
		if did_mom_already_talk:
			$HBoxContainer/Son.play("sad")
		else:
			is_Son_talking = true
			is_Son_opening = true
			$HBoxContainer/Son.play("open_mouth")
		
func _play_mom_message():
	if !did_mom_already_talk:
		$MessageFill.set_message(MOM_MESSAGES[current_mom_message])
		$HBoxContainer/Mom/LetterSpawner.show_message(MOM_MESSAGES[current_mom_message])
		current_mom_message += 1
	else:
		$MessageFill.set_message(MOM_SECOND_MESSAGES[current_mom_message])
		$HBoxContainer/Mom/LetterSpawner.show_message(MOM_SECOND_MESSAGES[current_mom_message])
		current_mom_message += 1
	
func _on_message_finished():
	yield(get_tree().create_timer(1), "timeout")
	if is_Mom_talking:
		if did_mom_already_talk and current_mom_message < len(MOM_SECOND_MESSAGES):
			_play_mom_message()
		elif !did_mom_already_talk and current_mom_message < len(MOM_MESSAGES):
			_play_mom_message()
		else:
			$MessageFill.clear_message()
			$HBoxContainer/Mom.play("close_mouth")
	else:
		did_win = true
		_end_game()

func _on_Son_animation_finished():
	if !did_mom_already_talk:
		if is_Son_opening:
			var challenge_text = _generate_random_string()
			$MessageFill.set_message(challenge_text)
			$HBoxContainer/Son/LetterSpawner.set_listening(true)
			_start_timer()
			is_Son_opening = false
		else:
			did_mom_already_talk = true
			is_Mom_opening = true
			is_Mom_talking = true
			current_mom_message = 0
			$HBoxContainer/Mom.play("sad_open_mouth")
	else:
		emit_signal("scene_ended")

func _generate_random_string():
	var output = ""
	for i in range(RANDOM_STRING_LENGTH):
		output += ALPHABET[rng.randi_range(0, 25)]
	return output
	
func _start_timer():
	$TimeLabel.text = str(time_remaining)
	$SecondTimer.start()
	
func _end_game():
	$HBoxContainer/Son/LetterSpawner.set_listening(false)
	$SecondTimer.stop()
	$TimeLabel.text = ""
	$MessageFill.clear_message()
	$HBoxContainer/Son.play("close_mouth")
	if did_win:
		emit_signal("game_ended", true)
	else:
		emit_signal("game_ended", false)

func _on_SecondTimer_timeout():
	time_remaining -= 1
	if time_remaining == 0:
		_end_game()
	else:
		$TimeLabel.text = str(time_remaining)
		
func _on_letter_processed(letter, is_correct):
	if letter.capitalize() in ALPHABET: 
		if is_Mom_talking:
			$HBoxContainer/Mom/LetterSpawner.instance_letter(letter, is_correct)
		else:
			$HBoxContainer/Son/LetterSpawner.instance_letter(letter, is_correct)


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
