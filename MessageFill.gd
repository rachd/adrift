extends MarginContainer

var _next_letter
var _message

func set_message(message):
	_message = message
	$Label.text = message
	$Label2.text = message
	$Label2.visible_characters = 0
	_next_letter = 0
	
func _on_letter_entered(letter):
	if letter == _message[_next_letter]:
		if letter != " ":
			$Label2.visible_characters += 1
		_next_letter += 1