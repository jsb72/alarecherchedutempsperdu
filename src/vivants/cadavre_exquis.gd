extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
func set_default_anim():
	animated_sprite_2d.play("default")

func _physics_process(delta: float) -> void:

	
	if is_on_floor():
		if animated_sprite_2d.animation!="dead": animated_sprite_2d.play("dead")

	if animated_sprite_2d.animation!="dead" or 1:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
