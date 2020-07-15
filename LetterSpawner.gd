extends Node2D

signal message_finished
signal letter_entered

export var left_path = false
var letter_prototype = preload("res://LetterScene.tscn")

func _instance_letter(letter):
	var letter_scene = letter_prototype.instance()
	letter_scene.set_text(letter)
	letter_scene.spawn(left_path)
	add_child(letter_scene)
	
func show_message(message):
	for letter in message:
		yield(get_tree().create_timer(0.2), "timeout")
		_instance_letter(letter)
		emit_signal("letter_entered", letter)
	emit_signal("message_finished")
	
func _ready():
	self.connect("message_finished", get_node("/root/MouthTextDream"), "_on_message_finished")
	self.connect("letter_entered", get_node("/root/MouthTextDream/MessageFill"), "_on_letter_entered")