extends Node2D

signal letter_entered

export var left_path = false
var letter_prototype = preload("res://LetterScene.tscn")
var _is_listening = false

func instance_letter(letter, is_correct):
	var letter_scene = letter_prototype.instance()
	letter_scene.set_text(letter, is_correct)
	letter_scene.spawn(left_path)
	add_child(letter_scene)
	
func show_message(message):
	for letter in message:
		yield(get_tree().create_timer(0.2), "timeout")
		emit_signal("letter_entered", letter)
	
func set_listening(is_listening):
	_is_listening = is_listening
	
func _ready():
	self.connect("letter_entered", get_node("/root/MouthTextDream/MessageFill"), "_on_letter_entered")

func _unhandled_input(event):
	if _is_listening and event is InputEventKey:
		if event.pressed:
			var letter = OS.get_scancode_string(event.scancode)
			emit_signal("letter_entered", letter)