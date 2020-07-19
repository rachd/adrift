extends KinematicBody2D

signal reached_exit

var speed = 80
var jumpForce : int = 80
var gravity : int = 80
var vel = Vector2(1, 0)
var did_hit = false
var is_jumping = false

func _is_on_floor():
	return self.position.y >= 121
	
func is_at_peak():
	return self.position.y <= 91
	

func _physics_process(delta):
	if Input.is_action_pressed("jump") and _is_on_floor():
		is_jumping = true
		vel.y -= jumpForce * delta
	elif is_jumping and is_at_peak():
		vel.y += 2 * jumpForce * delta
		is_jumping = false
	elif _is_on_floor():
		vel.y = 0
#	vel = vel.normalized()

	var collision_info = move_and_collide(vel * speed * delta)
	if collision_info and collision_info.collider.name == 'ChaseDoor' and !did_hit:
		did_hit = true
		emit_signal("reached_exit")
		
func _ready():
	self.connect("reached_exit", get_node("/root/SailingDay/ChaseDream"), "_on_reached_door")