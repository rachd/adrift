extends KinematicBody2D

signal player_hit

var speed = 150
var vel = Vector2(1, 0.4)
var did_hit = false

func _physics_process(delta):
	var collision_info = move_and_collide(vel * speed * delta)
	if collision_info and collision_info.collider.name == 'ChasePlayer' and !did_hit:
		self.queue_free()
		did_hit = true
		emit_signal("player_hit")
		
		
func _ready():
	self.connect("player_hit", get_node("/root/SailingDay/ChaseDream"), "_on_player_hit")