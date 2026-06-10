extends Node2D


@onready var player: Player = %Player
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var sprite: Sprite2D = $sprite
@onready var animation_player: AnimationPlayer = $sprite/AnimationPlayer

@onready var sprite_2d: Sprite2D = $sprite/Sprite2D
@onready var sprite_2d_2: Sprite2D = $sprite/Sprite2D2
@onready var sprite_2d_3: Sprite2D = $sprite/Sprite2D3

@onready var touchedsong: AudioStreamPlayer2D = $touchedsong
@onready var particle: CPUParticles2D = $sprite/particle
@onready var cam: PhantomCamera2D = %cam
@onready var cam_2: PhantomCamera2D = %cam2






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.door2_opened:
		global_position.y += -400.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.door2_opened:
		cam.limit_right = 10000000
		cam_2.limit_right = 10000000

		
	if Global.nb_fractal == 0:
		sprite_2d.visible = false
		sprite_2d_2.visible = false
		sprite_2d_3.visible = false
	if Global.nb_fractal == 1:
		sprite_2d.visible = true
		sprite_2d_2.visible = false
		sprite_2d_3.visible = false
	if Global.nb_fractal == 2:
		sprite_2d.visible = true
		sprite_2d_2.visible = true
		sprite_2d_3.visible = false
	if Global.nb_fractal == 3:
		sprite_2d.visible = true
		sprite_2d_2.visible = true
		sprite_2d_3.visible = true
	
	if !Global.door2_opened:
		if player.global_position.x > global_position.x - (400+267) and Global.nb_fractal >=3 :
			Global.door2_opened= true
			
			
			
	
			
			collision_shape_2d.set_deferred("disabled", true)
			
			animation_player.play("opendoor")
			particle.restart()
			
			
			player.shakecamtimer.start()
			touchedsong.play()
			await get_tree().create_timer(1.1).timeout
			
			
			player.shakecamtimer.start()
			touchedsong.play()
			await get_tree().create_timer(1.1).timeout
			
			
			player.shakecamtimer.start()
			touchedsong.play()
			
			await get_tree().create_timer(1.1).timeout
			Global.nb_fractal = 0
