extends KinematicBody2D

var speed = 80
var vel = Vector2(1, 0)
var rng = RandomNumberGenerator.new()
var fireball_scene = preload("res://Fireball.tscn")

func _physics_process(delta):
	var collision_info = move_and_collide(vel * speed * delta)
	
func _set_wait_time():
	$Timer.wait_time = rng.randf_range(1, 2)
	$Timer.start()
	
func _ready():
	rng.randomize()
	_set_wait_time()

func _on_Timer_timeout():
	var fireball = fireball_scene.instance()
	fireball.position.x = 16
	fireball.position.y = -8
	$AudioStreamPlayer.play()
	add_child(fireball)
	_set_wait_time()
