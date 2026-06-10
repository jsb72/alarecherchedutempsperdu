extends CharacterBody2D
class_name Ball

var jump_velocity = 560
@export var starting_vel = Vector2(0,0)
@export var bouncing = false
@onready var bouing: AudioStreamPlayer2D = $bouing

var inside_portal : bool = false
var inside_nojump_portal : bool = false
var save_velocity : Vector2
func portal_logic():
	if !is_on_floor() and !is_on_wall():
		save_velocity = velocity
	else :
		if !inside_portal : save_velocity.y = -jump_velocity
		
func _ready() -> void:
	velocity = starting_vel
	
func _physics_process(delta: float) -> void:
	portal_logic()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	
	if !inside_nojump_portal and bouncing:
		var collision: KinematicCollision2D = move_and_collide(velocity * delta)
		if collision:
			var reflect = collision.get_remainder().bounce(collision.get_normal())
			velocity = velocity.bounce(collision.get_normal())
			move_and_collide(reflect)
			bouing.play()
	elif !bouncing :
		move_and_slide()
