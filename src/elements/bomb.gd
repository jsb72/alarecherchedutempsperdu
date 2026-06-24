extends RigidBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation=randfn(-0.3, 0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		audio_stream_player_2d.play()
		#process_mode=Node.PROCESS_MODE_DISABLED
		body.dmgshaketimer.start()
		if body.self_control:
			body.animationdistorsion.stop()
			body.animationdistorsion.play("new_animation")
		animation_player.play("new_animation")
		var dir_ = body.global_position-global_position
		
		if dir_.y > 0 :
			dir_.y = dir_.y * -1
		
		var normal_dir = dir_.normalized()
		
		body.velocity=normal_dir*1500
		
		#hide()
		
