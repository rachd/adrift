extends KinematicBody2D

signal found_evil_spirit
signal found_spirit

var speed = 80
var vel = Vector2()
var facingDir = Vector2()
var did_hit = false

onready var sprite = $AnimatedSprite

func _physics_process(delta):
	vel = Vector2()
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0, -1)
		sprite.play("up")
	elif Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0, 1)
		sprite.play("down")
	elif Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1, 0)
		sprite.play("left")
	elif Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1, 0)
		sprite.play("right")
	else:
		sprite.play("idle")
	vel = vel.normalized()

	var collision_info = move_and_collide(vel * speed * delta)
	if !did_hit:
		if collision_info and collision_info.collider.name == 'EvilMazeSpirit':
			did_hit = true
			speed = 0
			emit_signal("found_evil_spirit")
		elif collision_info and collision_info.collider.name == 'MazeSpirit':
			did_hit = true
			speed = 0
			emit_signal("found_spirit")
		
func _ready():
	self.connect("found_evil_spirit", get_node("/root/SailingDay/MazeDream"), "_on_found_evil_spirit")
	self.connect("found_spirit", get_node("/root/SailingDay/MazeDream"), "_on_found_spirit")