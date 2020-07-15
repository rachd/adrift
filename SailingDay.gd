extends Node2D

var dialog = {
	001: "This is the first text.  It should set the scene.",
	002: "This is the second text.  It should tell more about the character.",
	003: "This is the third text.  More story development and generally interesting content."
}

var current_text = null;

func _set_next_text():
	if !current_text:
		current_text = 001
	elif current_text == 001 || current_text == 002:
		current_text += 1
	$textbox.set_text(dialog[current_text]);

func _ready():
	_set_next_text();

func _on_next_message():
	_set_next_text()