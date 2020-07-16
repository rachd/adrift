extends MarginContainer

signal message_finished
signal letter_processed(letter, is_correct)

var _next_letter
var _message

func set_message(message):
	_message = message
	$Label.text = message
	$Label2.text = message
	$Label2.visible_characters = 0
	_next_letter = 0
	
func clear_message():
	_message = ""
	$Label.text = _message
	$Label2.text = _message
	
func _on_letter_entered(letter):
	if _next_letter < len(_message) and letter.capitalize() == _message[_next_letter].capitalize():
		emit_signal("letter_processed", letter, true)
		if letter != " ":
			$Label2.visible_characters += 1
		_next_letter += 1
		if _next_letter == len(_message):
			emit_signal("message_finished")
	else:
		emit_signal("letter_processed", letter, false)
			
func _ready():
	self.connect("message_finished", get_node("/root/SailingDay/MouthTextDream"), "_on_message_finished")
	self.connect("letter_processed", get_node("/root/SailingDay/MouthTextDream"), "_on_letter_processed")