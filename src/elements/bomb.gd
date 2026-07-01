extends RigidBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@export var should_disapear:bool=true
var is_disapearing:bool=false
@onready var disapeartimer: Timer = $disapeartimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation=randfn(-0.3, 0.3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !is_disapearing:
		audio_stream_player_2d.play()
		animation_player.play("new_animation")
		
		if body.is_multiplayer_authority():
			body.dmgshaketimer.start()
			body.animationdistorsion.stop()
			body.animationdistorsion.play("new_animation")
			var dir_ = body.global_position-global_position
			
			if dir_.y > 0 :
				dir_.y = dir_.y * -1
			
			var normal_dir = dir_.normalized()
			
			body.velocity=normal_dir*1500
			
		delete_me_plz()
		


func _on_disapeartimer_timeout() -> void:
	if should_disapear:delete_me_plz()


func delete_me_plz()->void:
	is_disapearing=true
	#self.set_collision_mask_value(5, false)
	set_collision_layer_value(1, false)
	
	await get_tree().create_timer(1).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "modulate:a", 0.0, 1)
	
	await get_tree().create_timer(2).timeout
	hide()
	set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
