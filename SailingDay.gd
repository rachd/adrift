extends Node2D
onready var tween_out = get_node("Tween")

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var mouth_text_dream = preload("res://MouthTextDream.tscn")

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

func _set_next_text():
	var dialog_set = dialog[day]
	if message_index < len(dialog_set):
		current_text = dialog_set[message_index]
		message_index += 1
		$textbox.set_text(current_text);
	else:
		_cue_next_scene()
	

func _ready():
	_set_next_text();
	$HealthBar.set_health(health)
	
func _on_next_message():
	_set_next_text()

func _cue_next_scene():
	if day == 0:
		var next_scene = mouth_text_dream.instance()
		_fade_out($AudioStreamPlayer)
		add_child(next_scene)

func _start_next_day():
	day += 1
	message_index = 0
	$AudioStreamPlayer.play()
	_set_next_text()
	
func _on_game_output(did_win):
	if did_win:
		health += 20
		is_win = true
	else:
		health -= 20
		is_win = false
	$HealthBar.set_health(health)

func _fade_out(stream_player):
    # tween music volume down to 0
    tween_out.interpolate_property(stream_player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
    tween_out.start()
    # when the tween ends, the music will be stopped

func _on_TweenOut_tween_completed(object, key):
    # stop the music -- otherwise it continues to run at silent volume
    object.stop()