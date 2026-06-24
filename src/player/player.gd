class_name Player
extends CharacterBody2D

signal wall_entered
signal wall_exited

@export var self_control:bool=false

@export var color_dress:Color

@export var flip_h: bool: set = set_flip_h

@export_group("Horizontal Movement")
@export var max_speed_init: float
@onready var max_speed: float=max_speed_init
@export_range(1.0, 15.0) var max_h_velocity_ratio: float # Multiplied by max_speed

@export_subgroup("On Floor")
@export_range(0.0, 1.0) var running_acc_time: float
@export_range(0.0, 1.0) var running_dec_time: float

@export_subgroup("In Air")
@export_range(0.0, 1.0) var jumping_acc_time: float
@export_range(0.0, 1.0) var jumping_dec_time: float
@export_range(0.0, 1.0) var falling_acc_time: float
@export_range(0.0, 1.0) var falling_dec_time: float

@export_group("Vertical Movement")
@export_subgroup("Gravity")
@export_range(1.0, 2.0) var jump_not_held_gravity_ratio: float
@export_range(1.0, 2.0) var down_held_gravity_ratio: float
@export var gravity_limit: float
@export_range(1.0, 2.0) var down_held_gravity_limit_ratio: float

@export_subgroup("Jump")
@export var jump_height: float
@export_range(0.0, 1.0) var jump_time_to_peak: float
@export_range(0.0, 1.0) var jump_time_to_land: float
@export_range(1.0, 5.0) var max_up_velocity_ratio: float # Multiplied by jump_velocity
@export var jump_peak_boost: float # Boost applied to horizontal velocity after reaching jump peak
@export_range(0.0, 1.0) var jump_peak_gravity_ratio: float
@export var corner_correction_distance: int
@export var oneway_platform_assist_distance: int

@export_group("On Wall")
@export_subgroup("Wall Slide")
@export var max_wall_slide_speed: float
@export_range(1.0, 2.0) var down_held_wall_slide_ratio: float
@export_range(0.0, 1.0) var wall_slide_acc_time: float # Downward acceleration

@export_subgroup("Wall Jump")
@export_range(0.0, 1.0) var wall_jump_v_velocity_ratio: float # Multiplied by jump_velocity
@export var wall_jump_h_velocity: float
# Horizontal acceleration/deceleration after wall jumping.
@export_range(0.0, 1.0) var wall_jumping_acc_time: float
@export_range(0.0, 1.0) var wall_jumping_dec_time: float
@export_range(0.0, 1.0) var wall_jumping_towards_wall_dec_time: float # While the player is moving towards the wall

@export_group("Dash")
@export var dash_speed: float
@export var dash_distance: float
@export var after_dash_speed: float
@export_range(0.0, 1.0) var after_dash_gravity_ratio: float

@export_group("Animation")
@export_range(-90.0, 90.0, 0.1, "degrees") var max_move_skew: float
@export_range(0.0, 1.0) var shape_rescale_weight: float

@export_subgroup("Squash")
@export_range(1.0, 2.0) var squash_width_scale_at_rest: float
@export_range(1.0, 2.0) var squash_width_scale_at_max_fall: float
@export_range(0.0, 1.0) var squash_height_scale_at_rest: float
@export_range(0.0, 1.0) var squash_height_scale_at_max_fall: float

@export_subgroup("Stretch")
@export_range(0.0, 1.0) var stretch_width_scale: float
@export_range(1.0, 2.0) var stretch_height_scale: float

var dash_allowed: bool = false
var _on_wall: bool = false: # This variable mustn't be edited manually
	set(value):
		if value != _on_wall:
			(wall_entered if value else wall_exited).emit()
		
		_on_wall = value

@onready var jump_velocity: float = -(2.0 * jump_height) / jump_time_to_peak
@onready var max_up_velocity: float = jump_velocity * max_up_velocity_ratio
@onready var max_h_velocity: float = max_speed * max_h_velocity_ratio
@onready var jumping_gravity: float = (2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)
@onready var falling_gravity: float = (2.0 * jump_height) / (jump_time_to_land * jump_time_to_land)

@onready var shape: Node2D = $Shape as Node2D
@onready var state_machine: StateMachine = $StateMachine as StateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D as CollisionShape2D

@onready var jump_peak_gravity_timer: Timer = %JumpPeakGravity as Timer
@onready var jump_coyote_timer: Timer = %JumpCoyote as Timer
@onready var jump_buffer_timer: Timer = %JumpBuffer as Timer
@onready var wall_jump_coyote_timer: Timer = %WallJumpCoyote as Timer
@onready var wall_jump_buffer_timer: Timer = %WallJumpBuffer as Timer
@onready var dash_cooldown_timer: Timer = %DashCooldown as Timer
@onready var after_dash_gravity_timer: Timer = %AfterDashGravity as Timer

@onready var _default_shape_scale: Vector2 = shape.scale

var can_double_jump : bool = true

var is_bouncing:bool=false

@onready var wall_ray_right_2: RayCast2D = $rays/WallRayRight2
@onready var wall_ray_left_2: RayCast2D = $rays/WallRayLeft2
@onready var wall_ray_right_3: RayCast2D = $rays/WallRayRight3
@onready var wall_ray_left_3: RayCast2D = $rays/WallRayLeft3


func _ready() -> void:
	var mygradient:GradientTexture2D=sprite.material.get_shader_parameter("pal0")
	mygradient.gradient.set_color(1,color_dress)
	sprite.material.set_shader_parameter("pal0", mygradient)
	
func _physics_process(_delta: float) -> void:
	var there_is_wall = is_there_a_wall_here()
	if there_is_wall!=0:
		_on_wall = true
	else :
		_on_wall = false
	#_on_wall = is_on_wall()
	if is_action_pressed_custom("item"):
		launch_bomb()
	logic_spe()
	
func is_action_pressed_custom(action_name:String,just_pressed_option:bool=true) -> bool:
	if self_control:
		if just_pressed_option:
			if Input.is_action_just_pressed(action_name):
				return true
		else:
			if Input.is_action_pressed(action_name):
				return true
	else:
		pass
		
	return false

func get_input_vector() -> Vector2:
	if dead_: 
		return Vector2(0,0)
	else : 
		if self_control:
			return Input.get_vector("left", "right", "up", "down")
		else:
			return Vector2(0,0)

func try_double_jump() -> void:
	if jump_coyote_timer.is_stopped():
		if is_action_pressed_custom("jump") and can_double_jump and Global.doublejump_unlock and !dead_:
			jump()
			can_double_jump = false	

func get_facing_dir() -> float:
	return -1.0 if flip_h else 1.0

"""var facing_dir_save_walljump:float=1.0"""
func set_flip_h(value: bool) -> void:
	if not is_node_ready():
		await ready
	
	flip_h = value
	shape.scale.x = absf(shape.scale.x) * get_facing_dir()
	sprite.scale.x = absf(sprite.scale.x) * get_facing_dir()
	"""if !state_machine.active_state is WallJumpState:
		sprite.scale.x = absf(sprite.scale.x) * get_facing_dir()
	else:
		sprite.scale.x =absf(sprite.scale.x) * facing_dir_save_walljump*-1"""

func update_flip_h() -> void:
	var h_input_dir: float = signf(get_input_vector().x)
	
	if h_input_dir:
		flip_h = h_input_dir != 1.0
		"""if state_machine.active_state is WallSlideState:
			flip_h=!flip_h"""

func apply_movement(delta: float, acc_time: float, dec_time: float) -> void:
	var speed_dir: float = max_speed * get_input_vector().x
	var h_velocity_dir: float = signf(velocity.x)
	var apply_acc: bool = (
			h_velocity_dir == 0.0
			or (velocity.x - speed_dir) * h_velocity_dir <= 0.0
	)
	
	var step: float = max_speed / (acc_time if apply_acc else dec_time)
	
	velocity.x = move_toward(velocity.x, speed_dir, step * delta)
	velocity.x = clampf(velocity.x, -max_h_velocity, max_h_velocity)

func apply_gravity(delta: float) -> void:
	velocity.y += calculate_gravity() * delta
	velocity.y = clampf(velocity.y, max_up_velocity, calculate_gravity_limit())
	#if dead_:velocity.y = 0

func get_default_gravity() -> float:
	return falling_gravity if velocity.y >= 0.0 else jumping_gravity

func calculate_gravity() -> float:
	return get_default_gravity() * (
			jump_peak_gravity_ratio if not jump_peak_gravity_timer.is_stopped() or is_bouncing
			else after_dash_gravity_ratio if not after_dash_gravity_timer.is_stopped()
			else jump_not_held_gravity_ratio if not is_action_pressed_custom("jump",false) or is_bouncing
			else down_held_gravity_ratio if is_action_pressed_custom("down",false) and velocity.y > 0
			else 1.0
	)

func calculate_gravity_limit() -> float:
	return gravity_limit * (
			down_held_gravity_ratio if is_action_pressed_custom("down",false) and velocity.y > 0
			else 1.0
	)

func jump() -> void:
	is_bouncing=false
	is_sliding=false
	velocity.y = jump_velocity
	apply_stretch()
		
	try_play_new_anim("jumpup")
	jump_sound.play()
	jump_particle.restart()

func try_jump() -> void:
	if is_action_pressed_custom("jump") and !dead_:
		jump()

func try_coyote_jump() -> void:
	if not jump_coyote_timer.is_stopped():
		try_jump()
		

func try_jump_buffer_timer() -> void:
	if is_action_pressed_custom("jump"):
		jump_buffer_timer.start()

func try_buffer_jump() -> void:
	if not jump_buffer_timer.is_stopped():
		jump()

func stop_jump_timers() -> void:
	jump_coyote_timer.stop()
	jump_buffer_timer.stop()
	wall_jump_coyote_timer.stop()
	wall_jump_buffer_timer.stop()

var the_last_wall_dir:int=1
func is_there_a_wall_here()-> int:
	var is_there_a_wall:int=0
	
			
	if wall_ray_right_2.is_colliding():
		var collidobj = wall_ray_right_2.get_collider()
		if collidobj is TileMapLayer :
			is_there_a_wall=1
			the_last_wall_dir=1
	if wall_ray_left_2.is_colliding():
		var collidobj = wall_ray_left_2.get_collider()
		if collidobj is TileMapLayer :
			is_there_a_wall=-1
			the_last_wall_dir=-1
			
	if wall_ray_right_3.is_colliding():
		var collidobj = wall_ray_right_3.get_collider()
		if collidobj is TileMapLayer :
			is_there_a_wall=1
			the_last_wall_dir=1
	if wall_ray_left_3.is_colliding():
		var collidobj = wall_ray_left_3.get_collider()
		if collidobj is TileMapLayer :
			is_there_a_wall=-1
			the_last_wall_dir=-1
			
	return is_there_a_wall
	
func get_last_wall_dir() -> float:
	return the_last_wall_dir
	#return -signf(get_wall_normal().x)

func apply_wall_slide(delta: float) -> void:
	var step: float = max_wall_slide_speed / wall_slide_acc_time
	velocity.y = move_toward(velocity.y, calculate_wall_slide_speed(), step * delta)

func can_wall_slide() -> bool:
	# Can wall slide if the player is touching the wall and moving towards it.
	#return is_on_wall() and get_input_vector().x * get_last_wall_dir() > 0
	var isonwall=false
	var input_x=get_input_vector().x
	
	
	var is_there_a_wall=is_there_a_wall_here()
	if is_there_a_wall==1 and input_x > 0:
		isonwall=true
	if is_there_a_wall==-1 and input_x < 0:
		isonwall=true
			
	return isonwall
	
var is_sliding:bool=false
var waitplayslideanim:bool=false
func try_wall_slide() -> void:
	if can_wall_slide():
		state_machine.activate_state_by_name("WallSlideState")
		
		"""if !is_sliding:try_play_new_anim("slide_enter")
		else:"""
			
		is_sliding=true
		try_play_new_anim("slide")
		"""if sprite.animation=="slide_enter" and sprite.frame==3:
			try_play_new_anim("slide")"""
		"""await get_tree().create_timer(0.1).timeout
		if is_sliding:
			try_play_new_anim("slide")
			
			print("slide")"""
	else:
		is_sliding=false
		
		

func calculate_wall_slide_speed() -> float:
	return max_wall_slide_speed * (
			down_held_wall_slide_ratio if is_action_pressed_custom("down",false)
			else 1.0
	)

func wall_jump() -> void:
	is_bouncing=false
	is_sliding=false
	var wall_jump_dir: float = -get_last_wall_dir()
	
	velocity.y = jump_velocity * wall_jump_v_velocity_ratio
	velocity.x = wall_jump_h_velocity * wall_jump_dir
	apply_stretch()
	
	state_machine.activate_state_by_name("WallJumpState")
		
	try_play_new_anim("walljumpup")
	walljump_sound.play()
	jump_particle.restart()
	
	"""facing_dir_save_walljump=get_facing_dir()"""
	
	

func try_wall_jump(ignore_wall: bool = false) -> void:
	if is_action_pressed_custom("jump") and (is_there_a_wall_here()!=0 or ignore_wall) and Global.walljump_unlock and !dead_:
		wall_jump()

func try_coyote_wall_jump() -> void:
	if not wall_jump_coyote_timer.is_stopped():
		try_wall_jump(true)

func try_wall_jump_buffer_timer() -> void:
	if is_action_pressed_custom("jump"):
		wall_jump_buffer_timer.start()

func _on_wall_entered() -> void:
	if not wall_jump_buffer_timer.is_stopped():
		wall_jump()

func _on_wall_exited() -> void:
	if velocity.y > 0:
		wall_jump_coyote_timer.start()

func calculate_wall_jumping_dec_time() -> float:
	var h_input_dir: float = signf(get_input_vector().x)
	
	return (
			wall_jumping_towards_wall_dec_time if h_input_dir == get_last_wall_dir()
			else wall_jumping_dec_time
	)

func can_dash() -> bool:
	return dash_allowed and dash_cooldown_timer.is_stopped()

func try_dash() -> void:
	if is_action_pressed_custom("dash") and can_dash() and Global.dash_unlock and !dead_:
		state_machine.activate_state_by_name("DashState")
		dash_sound.play()
		is_sliding=false

func try_corner_correction(delta: float) -> void:
	var v_motion: Vector2 = Vector2(0.0, velocity.y * delta)
	
	if not test_move(global_transform, v_motion):
		return
	
	# Multiplied by 2 so each offset increments by 0.5 instead of 1.0.
	for offset_step: int in range(1, corner_correction_distance * 2 + 1):
		var offset: float = offset_step / 2.0
	
		for dir: float in [-1.0, 1.0]:
			var h_offset: Vector2 = Vector2(offset * dir, 0)
			var test_transform: Transform2D = global_transform.translated(h_offset)
			
			if not test_move(test_transform, v_motion):
				translate(h_offset)
				
				# Stop the player if they are moving opposite to the corner's direction.
				if velocity.x * dir < 0.0:
					velocity.x = 0.0
				
				return

func try_oneway_platform_assist() -> void:
	if test_move(global_transform, Vector2.DOWN):
		return
	
	# Multiplied by 2 so each offset increments by 0.5 instead of 1.0.
	for offset_step: int in range(oneway_platform_assist_distance * 2 + 1):
		var offset: float = offset_step / 2.0
		var v_offset: Vector2 = Vector2.UP * offset
		
		var test_transform: Transform2D = global_transform.translated(v_offset)
		
		if test_move(test_transform, Vector2.DOWN):
			# Make sure the player doesn't get stuck.
			if not test_move(test_transform, Vector2.UP):
				translate(v_offset)
			
			return

func apply_move_anim() -> void:
	var max_move_skew_rad: float = deg_to_rad(max_move_skew)
	
	shape.skew = remap(velocity.x, -max_speed, max_speed, -max_move_skew_rad, max_move_skew_rad)
	#sprite.skew = remap(velocity.x, -max_speed, max_speed, -max_move_skew_rad, max_move_skew_rad)

func update_shape_scale(delta: float) -> void:
	var target: Vector2 = _default_shape_scale * shape.scale.sign()
	var target2: Vector2 = _default_sprite_scale * sprite.scale.sign()
	var frame_weight: float = 1.0 - pow(1.0 - shape_rescale_weight, 60.0 * delta)
	
	shape.scale = shape.scale.lerp(target, frame_weight)
	sprite.scale = sprite.scale.lerp(target2, frame_weight)

func apply_squash() -> void:
	var max_fall_speed: float = calculate_gravity_limit()
	var vertical_speed: float = get_position_delta().y / get_physics_process_delta_time()
	
	shape.scale.x *= remap(vertical_speed, 0.0, max_fall_speed, squash_width_scale_at_rest, squash_width_scale_at_max_fall)
	shape.scale.y *= remap(vertical_speed, 0.0, max_fall_speed, squash_height_scale_at_max_fall, squash_height_scale_at_rest)
	sprite.scale.x *= remap(vertical_speed, 0.0, max_fall_speed, squash_width_scale_at_rest, squash_width_scale_at_max_fall)
	sprite.scale.y *= remap(vertical_speed, 0.0, max_fall_speed, squash_height_scale_at_max_fall, squash_height_scale_at_rest)

func apply_stretch() -> void:
	shape.scale *= Vector2(stretch_width_scale, stretch_height_scale)
	sprite.scale *= Vector2(stretch_width_scale, stretch_height_scale)
	
	
	
	
	
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var _default_sprite_scale: Vector2 = sprite.scale

@onready var jump_sound: AudioStreamPlayer2D = $sounds/jump_sound
@onready var land_sound: AudioStreamPlayer = $sounds/land_sound
@onready var walljump_sound: AudioStreamPlayer = $sounds/walljump_sound
@onready var dash_sound: AudioStreamPlayer = $sounds/dash_sound
@onready var slide_sound: AudioStreamPlayer = $sounds/slide_sound
@onready var falling_sound: AudioStreamPlayer = $sounds/falling_sound
@onready var run_sound: AudioStreamPlayer = $sounds/run_sound

@onready var jump_particle: CPUParticles2D = $particles/jump_particle
@onready var ground_particle: CPUParticles2D = $particles/ground_particle
@onready var slide_particle: CPUParticles2D = $particles/slide_particle
@onready var run_particle: CPUParticles2D = $particles/run_particle
@onready var blood_particle: CPUParticles2D = $particles/blood_particle

@onready var point_light_2d: PointLight2D = $lights/PointLight2D
@onready var point_light_2d_2: PointLight2D = $lights/PointLight2D2

@onready var cam: PhantomCamera2D = %cam

@onready var groundshaketimer: Timer = $shakecamtimers/groundshaketimer
@onready var dmgshaketimer: Timer = $shakecamtimers/dmgshaketimer

@onready var animationdistorsion: AnimationPlayer = $CanvasLayer/distorsionrect/animationdistorsion



func logic_spe():
	if self_control:
		Engine.time_scale = 1
		if is_action_pressed_custom("skill",false):
				Engine.time_scale = 0.1
			
	sprite_animation()
	
	particle_animation()
	
	sound_animation()
	
	camera_logic()
	
	

var cam_offset_x:int=50
var cam_offset_y:int=0

func camera_logic()->void:
	"""if velocity.x > 0 and is_on_floor_only(): 
		var tween = get_tree().create_tween()
		tween.tween_property(cam, "follow_offset", Vector2(50,0), 1.0)
	if velocity.x < 0 and is_on_floor_only(): 
		var tween = get_tree().create_tween()
		tween.tween_property(cam, "follow_offset", Vector2(-50,0), 1.0)"""
	
	cam_offset_y=0
	if is_action_pressed_custom("cam_top",false):
		cam_offset_y=-400
	if is_action_pressed_custom("cam_bot",false):
		cam_offset_y=400
		
	var tweenfdf = get_tree().create_tween()
	tweenfdf.tween_property(cam, "follow_offset:y", cam_offset_y, 1.0)
		
	if velocity.x > 0 and is_on_floor_only(): 
		cam_offset_x=50
	if velocity.x < 0 and is_on_floor_only(): 
		cam_offset_x=-50
		
	var tween = get_tree().create_tween()
	tween.tween_property(cam, "follow_offset:x", cam_offset_x, 1.0)
	
		
	cam.noise.positional_noise= false
	Input.stop_joy_vibration(0)
	if state_machine.active_state is DashState:
		cam.noise.amplitude=20.0
		cam.noise.frequency=0.8
		cam.noise.positional_noise= true
		Input.start_joy_vibration(0,0.5,0.5)
	if !groundshaketimer.is_stopped():
		cam.noise.amplitude=5.0
		cam.noise.frequency=0.2
		cam.noise.positional_noise= true
		Input.start_joy_vibration(0,0.25,0.25)
	if!dmgshaketimer.is_stopped():
		cam.noise.amplitude=40.0
		cam.noise.frequency=2
		cam.noise.positional_noise= true
		Input.start_joy_vibration(0,0.5,0.5)
		

func try_play_new_anim(anim) -> void:
	if sprite.animation != anim or anim=="jumpup" or anim=="walljumpup":
		#sprite.rotation=rotation_
		
		"""var tween = get_tree().create_tween()
		tween.tween_property(sprite, "rotation", rotation_, 0.2)"""
		if anim=="jumpup":sprite.frame=0
		if anim=="walljumpup":sprite.frame=0
		sprite.play(anim)
		
var en_train_de_tomber = false
var idle_number : int = 1
func sprite_animation() -> void:
	if is_on_floor():is_sliding=false
	
	if !is_sliding:
		if is_on_floor() :
			if sprite.animation=="jumpground" and sprite.is_playing():
				pass
			else:
				if velocity.x < -0 or velocity.x > 0 :
					if is_on_floor_only():
						if velocity.x < -100 or velocity.x > 100 :
							try_play_new_anim("run")
						else:
							try_play_new_anim("run")
				else:
					var choose_idle = randi_range(0, 25)
					if choose_idle==0:
						if idle_number == 1:
							idle_number=2
						elif idle_number == 2:
							idle_number=1
					
					if idle_number == 1:
						try_play_new_anim("idle")
					elif idle_number == 2:
						try_play_new_anim("idle2")
					
		if velocity.y > 0.0:
			en_train_de_tomber = true
		if velocity.y > 10.0:
			try_play_new_anim("robe")
			
		if en_train_de_tomber and is_on_floor():
			groundshaketimer.start()
			try_play_new_anim("jumpground")
			en_train_de_tomber = false
		
		if state_machine.active_state is DashState :
			try_play_new_anim("dash")
			
func particle_animation() -> void:
	if is_sliding:
		if !dead_:slide_particle.emitting = true
		if get_facing_dir() < 0 :
			slide_particle.position.x = -13
		if get_facing_dir() > 0 :
			slide_particle.position.x = 13
	else :
		slide_particle.emitting = false
	
	run_particle.emitting = false
	if is_on_floor() :
		if sprite.animation=="jumpground" and sprite.is_playing():
			pass
		else:
			if velocity.x < -150 or velocity.x > 150 :
				run_particle.emitting = true
				
var saut_en_cours_for_sound = false
var falling_started = false
func sound_animation() -> void:
	if is_on_floor() and velocity.x != 0.0:
		if !run_sound.playing and !land_sound.playing : 
			run_sound.play()
	else :
		run_sound.stop()
		
	if is_sliding:
		if !slide_sound.playing and !dead_: slide_sound.play()
	else :
		slide_sound.stop()
		
		if velocity.y > 0 :
			if !falling_sound.playing : 
				if !falling_started:
					var tween = get_tree().create_tween()
					tween.tween_property(falling_sound, "volume_db", 0.0, 0.5)
					falling_started=true
				
				falling_sound.play()
		else :
			#if falling_started:shakecamtimer.start()
			falling_sound.stop()
			var tween = get_tree().create_tween()
			tween.tween_property(falling_sound, "volume_db", -80.0, 0.5)
			falling_started=false
			
		
	if velocity.y != 0.0 :
		saut_en_cours_for_sound = true
	if is_on_floor():
		if saut_en_cours_for_sound :
			saut_en_cours_for_sound = false
			if !respawned :
				land_sound.play()
				ground_particle.restart()
	
@onready var bomblist: Node2D = $"../bomblist"			
func launch_bomb():
	var bombspawedpacked = load("res://src/elements/bomb.tscn")
	var bombspawed = bombspawedpacked.instantiate()
	
	#bombspawed.scale=Vector2(0.5,0.5)
	bombspawed.global_position=global_position
	bombspawed.global_position.x+=64*get_facing_dir()
	bombspawed.global_position.y-=32
	bombspawed.linear_velocity=Vector2(1000*get_facing_dir(),-220)
	
	bombspawed.modulate.a = 0.0
	bomblist.add_child(bombspawed)
	var tween3 = get_tree().create_tween()
	tween3.tween_property(bombspawed, "modulate:a", 1.0, 0.25)
	
			
var last_floor_pos : Vector2= Vector2(1024,1216)
var respawned : bool = false
func respawn():
	var tween22 = get_tree().create_tween()
	tween22.tween_property(point_light_2d, "energy", 1.0, 1.0)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(point_light_2d_2, "energy", 1.0, 1.0)
	
	respawned=true
	
	dead_ = false
	
	global_position = last_floor_pos
	velocity = Vector2(0.0,0.0)
	
	sprite.show()
	deathspriteanim.hide()
	sprite.modulate.a = 0.0
	
	var tween3 = get_tree().create_tween()
	tween3.tween_property(sprite, "modulate:a", 1.0, 2.0)
	
	await get_tree().create_timer(2).timeout
	
	respawned=false
	

@onready var deathspriteanim: Node2D = $deathspriteanim

var dead_ : bool = false
func play_death_anim():
	if !Global.godmode:
	
		blood_particle.restart()
		dead_ = true
		
		sprite.hide()
		deathspriteanim.show()
		deathspriteanim.play("idle")
		
		if get_facing_dir() > 0 :
			deathspriteanim.flip_h = false
		if get_facing_dir() < 0 :
			deathspriteanim.flip_h = true
			
		var tween22 = get_tree().create_tween()
		tween22.tween_property(point_light_2d, "energy", 0.0, 0.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(point_light_2d_2, "energy", 0.0, 0.0)
		
		await get_tree().create_timer(1).timeout
		
		#deathspriteanim.modulate.s = 100
		
		deathspriteanim.play("death")
		
		"""var tween4 = get_tree().create_tween()
		tween4.tween_property(deathspriteanim, "modulate:s", 0.0, 2.0)"""
		
		
		
		await get_tree().create_timer(2).timeout
		respawn()
			
	
