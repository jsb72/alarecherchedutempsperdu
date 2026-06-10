extends Area2D
class_name Portal

@export var portal_target:Portal
@export var portal_reverse_color:bool = false
@export var black_portal:bool = false
@onready var sound: AudioStreamPlayer2D = $sound

@export var display_platformsprite:bool=true
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if !display_platformsprite:
		sprite_2d.hide()
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body is Ball:
		if !body.inside_portal:
			body.global_position = portal_target.global_position 
			
			#var magnitude = body.save_velocity.length()
			"""var magnitude = 1000
			var vecteur_droit = Vector2(0,-magnitude)
			var vecteur_rotated = vecteur_droit.rotated(portal_target.rotation)
			body.velocity = vecteur_rotated"""
			#body.velocity = Vector2(0,-2000)*portal_target.rotation
			var dir_ = Vector2(0,-1).rotated(portal_target.rotation)
			var normal_dir = dir_.normalized()
			body.velocity=normal_dir*1250
			
			body.can_double_jump = true
			
			body.inside_portal = true
			
			sound.play()
			#body.shakecamtimer.start()
			
			body.hide()
			await get_tree().create_timer(0.02).timeout
			body.show()
			
			await get_tree().create_timer(0.1).timeout
			body.inside_portal = false
			
	
