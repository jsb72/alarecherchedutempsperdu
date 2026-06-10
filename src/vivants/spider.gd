class_name Spider
extends CharacterBody2D

@onready var spiderrendu: Node2D = $spiderrendu
@onready var animated_sprite_2d: AnimatedSprite2D = $spiderrendu/AnimatedSprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var timer: Timer = $Timer

@onready var right: RayCast2D = $right
@onready var left: RayCast2D = $left
@onready var down: RayCast2D = $down
@onready var top: RayCast2D = $top

func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("right"):
		direction=1
	if Input.is_action_just_pressed("left"):
		direction=-1
	atk_logik()
	if !is_attacking():
		move_logic(delta)
		move_animation()
		

	
const SPEED = 50.0
var rng = RandomNumberGenerator.new()
var direction : int = 0
var last_surface : String = ""
var changement_de_surface:bool=false
@onready var changementdesurfacetimer: Timer = $changementdesurfacetimer
func move_logic(delta)->void:
	if last_surface=="":
		if getCollisionSurface(right):
			last_surface="right"
		if getCollisionSurface(left):
			last_surface="left"
		if getCollisionSurface(top):
			last_surface="top"
		if getCollisionSurface(down):
			last_surface="down"
			
	
	
	if last_surface=="down" and !changement_de_surface:
		if getCollisionSurface(right):
			last_surface="right"
			changementdesurfacefn("down")
		if getCollisionSurface(left):
			last_surface="left"
			changementdesurfacefn("down")
	if last_surface=="top" and !changement_de_surface:
		if getCollisionSurface(right):
			last_surface="right"
			changementdesurfacefn("top")
		if getCollisionSurface(left):
			last_surface="left"
			changementdesurfacefn("top")
	if last_surface=="right" and !changement_de_surface:
		if getCollisionSurface(top):
			last_surface="top"
			changementdesurfacefn("right")
		if getCollisionSurface(down):
			last_surface="down"
			changementdesurfacefn("right")
	if last_surface=="left" and !changement_de_surface:
		if getCollisionSurface(top):
			last_surface="top"
			changementdesurfacefn("left")
		if getCollisionSurface(down):
			last_surface="down"
			changementdesurfacefn("left")

	if direction :
		if last_surface=="top" or last_surface=="down":
			velocity.x = direction * SPEED
		if last_surface=="right" or last_surface=="left":
			velocity.y = direction * SPEED
	else:
		if last_surface=="top" or last_surface=="down":
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if last_surface=="right" or last_surface=="left":
			velocity.y = move_toward(velocity.y, 0, SPEED)
		
	move_and_slide()
	
	prevent_walk_in_air()
	
func changementdesurfacefn(old_surface)->void:
	changement_de_surface=true
	if old_surface=="down":
		if last_surface=="right":
			direction=-1
	if old_surface=="right":
		if last_surface=="top":
			direction=-1
	if old_surface=="top":
		if last_surface=="left":
			direction=1
	if old_surface=="left":
		if last_surface=="down":
			direction=1
			
	if old_surface=="down":
		if last_surface=="left":
			direction=-1
	if old_surface=="left":
		if last_surface=="top":
			direction=1
	if old_surface=="top":
		if last_surface=="right":
			direction=1
	if old_surface=="right":
		if last_surface=="down":
			direction=-1
	changementdesurfacetimer.start()

func _on_changementdesurfacetimer_timeout() -> void:
	changement_de_surface=false
	
	
func prevent_walk_in_air()->void:
	if !getCollisionSurface(right) and !getCollisionSurface(left) and !getCollisionSurface(top) and !getCollisionSurface(down) and !timer.paused:
		timer.paused=true
		direction=-direction
		await get_tree().create_timer(1).timeout
		timer.paused=false
		

func move_animation()->void:
	if direction == 0 :
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("walk")
		
	if last_surface=="top":
		spiderrendu.rotation_degrees=180
		if direction == -1 :
			spiderrendu.scale.x = 1
		if direction == 1 :
			spiderrendu.scale.x = -1
	if last_surface=="down":
		spiderrendu.rotation_degrees=0
		if direction == -1 :
			spiderrendu.scale.x = -1
		if direction == 1 :
			spiderrendu.scale.x = 1
	if last_surface=="right":
		spiderrendu.rotation_degrees=-90
		if direction == -1 :
			spiderrendu.scale.x = 1
		if direction == 1 :
			spiderrendu.scale.x = -1
	if last_surface=="left":
		spiderrendu.rotation_degrees=90
		if direction == -1 :
			spiderrendu.scale.x = -1
		if direction == 1 :
			spiderrendu.scale.x = 1
		
func atk_logik()->void:
	var bodycol_front :CharacterBody2D
	var bodycol_back :CharacterBody2D
	
	if last_surface=="top" or last_surface=="down":
		bodycol_front=getcollisionbody(right)
		bodycol_back=getcollisionbody(left)
	if last_surface=="right" or last_surface=="left":
		bodycol_front=getcollisionbody(top)
		bodycol_back=getcollisionbody(down)
	
	if bodycol_front !=null or bodycol_back !=null:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite_2d.play("attack")
		audio_stream_player_2d.play()
		
		if bodycol_back != null and bodycol_front == null:
			if last_surface=="down" or last_surface=="right":
				spiderrendu.scale.x = -1
			if last_surface=="top" or last_surface=="left":
				spiderrendu.scale.x = 1
			await get_tree().create_timer(0.1).timeout
			bodycol_back.position.x -= 3
		if bodycol_front != null and bodycol_back == null:
			if last_surface=="down" or last_surface=="right":
				spiderrendu.scale.x = 1
			if last_surface=="top" or last_surface=="left":
				spiderrendu.scale.x = -1
			await get_tree().create_timer(0.1).timeout
			bodycol_front.position.x += 3
			
func is_attacking()->bool:
	return animated_sprite_2d.animation == "attack" and animated_sprite_2d.is_playing()
	
func getcollisionbody(rcast:RayCast2D):
	if rcast.is_colliding():
		var collidobj = rcast.get_collider()
		if collidobj is Player :
			return collidobj
	return null

func getCollisionSurface(rcast:RayCast2D):
	if rcast.is_colliding():
		var collidobj = rcast.get_collider()
		if collidobj is StaticBody2D :
			return collidobj
	return null

func _on_timer_timeout() -> void:
	if !changement_de_surface : direction = rng.randi_range(-1, 1)
	
	timer.start()
