extends Area2D
@onready var animation_player: AnimationPlayer = $AntialiasedRegularPolygon2D/AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $AntialiasedRegularPolygon2D/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var color_dress:Color
	color_dress.v=0.75
	color_dress.s=1
	color_dress.h=randf_range(0,1)
	var value:=0.5
	#color_dress = (color_dress.srgb_to_linear() * 2 ** value).linear_to_srgb()
	
	sprite_2d.modulate=color_dress
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.is_bouncing=true
		
		body.global_position.y=global_position.y-20
		body.velocity.y = -750
		#body.velocity.y = -1200
		
		body.apply_stretch()
		body.try_play_new_anim("jumpup")
		body.groundshaketimer.start()
		body.jump_particle.restart()
		
		
		animation_player.play("new_animation")
		audio_stream_player_2d.play()
		
func _on_body_exited(body: Node2D) -> void:
	pass
