extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $spiderrendu/AnimatedSprite2D
@onready var spiderrendu: Node2D = $spiderrendu
@onready var rays: Node2D = $rays
@onready var vray: RayCast2D = $rays/vray
@onready var hray: RayCast2D = $rays/hray
@onready var blood_particle: CPUParticles2D = $blood_particle
@onready var turnangleexttimer: Timer = $turnangleexttimer
@onready var rotateanimtimer: Timer = $rotateanimtimer

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var speed_move:float = 0.6
var dead:bool=false

var angle:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randi_range(0, 1)==0:
		spiderrendu.scale.x=-1
		rays.scale.x=-1

func _process(delta: float) -> void:
	pass
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !dead:
		if getCollisionSurface(hray):
			if spiderrendu.scale.x==1:
				angle-=90
			if spiderrendu.scale.x==-1:
				angle+=90
		"""if !getCollisionSurface(vray):
			spiderrendu.scale.x*=-1
			if spiderrendu.scale.x==-1:
				angle=360+angle
			if spiderrendu.scale.x==1:
				angle=-angle"""
		if !getCollisionSurface(vray):
			#print("mais what")
			if turnangleexttimer.is_stopped():
				turnangleexttimer.start()
				
				var fixe_longueur:int=18*self.scale.x#9 à ajuster selon self.scale.x (1 =>18)
				var new_pos:Vector2=global_position
				
				if spiderrendu.scale.x==1:
					angle+=90
					if angle==90:
						angle=-270
						
					if angle==0:
						new_pos.y-=fixe_longueur
						new_pos.x+=fixe_longueur
					if angle==-90:
						new_pos.x-=fixe_longueur
						new_pos.y-=fixe_longueur
					if angle==-180:
						new_pos.y+=fixe_longueur
						new_pos.x-=fixe_longueur
					if angle==-270:
						new_pos.x+=fixe_longueur
						new_pos.y+=fixe_longueur
				
				if spiderrendu.scale.x==-1:
					angle-=90
					if angle==-90:
						angle=270
						
					if angle==0:
						new_pos.y-=fixe_longueur
						new_pos.x-=fixe_longueur
					if angle==90:
						new_pos.x+=fixe_longueur
						new_pos.y-=fixe_longueur
					if angle==180:
						new_pos.y+=fixe_longueur
						new_pos.x+=fixe_longueur
					if angle==270:
						new_pos.x-=fixe_longueur
						new_pos.y+=fixe_longueur
						
		
				var tween = get_tree().create_tween()
				tween.tween_property(self, "global_position", new_pos, 0.5)
				
		if angle==-360 or angle==360:
			angle=0
		
		rays.rotation_degrees=angle
		#spiderrendu.rotation_degrees=angle
		
		
		if spiderrendu.rotation_degrees!=angle:
			if rotateanimtimer.is_stopped():
				rotateanimtimer.start()
				
				if angle==-270 and spiderrendu.rotation_degrees==0:
					spiderrendu.rotation_degrees=-360
				if angle==270 and spiderrendu.rotation_degrees==0:
					spiderrendu.rotation_degrees=360
					
				if angle==0 and spiderrendu.rotation_degrees==-270:
					spiderrendu.rotation_degrees=90
				if angle==0 and spiderrendu.rotation_degrees==270:
					spiderrendu.rotation_degrees=-90
						
				var tween = get_tree().create_tween()
				tween.tween_property(spiderrendu, "rotation_degrees", angle, 0.5)
			
			
		if spiderrendu.scale.x==1:
			if angle==0:
				global_position.x+=speed_move
			if angle==-90:
				global_position.y-=speed_move
			if angle==-180:
				global_position.x-=speed_move
			if angle==-270:
				global_position.y+=speed_move
				
				
		if spiderrendu.scale.x==-1:
			if angle==0:
				global_position.x-=speed_move
			if angle==90:
				global_position.y-=speed_move
			if angle==180:
				global_position.x+=speed_move
			if angle==270:
				global_position.y+=speed_move
				
		
		
		animated_sprite_2d.play("walk")
	
func getCollisionSurface(rcast:RayCast2D):
	if rcast.is_colliding():
		var collidobj = rcast.get_collider()
		if collidobj is TileMapLayer :
			return true
	return false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !dead:
			if body.state_machine.active_state is FallState or body.state_machine.active_state is JumpState or body.state_machine.active_state is WallJumpState:
				dead=true
				animated_sprite_2d.play("death")
				audio_stream_player_2d.play()
				blood_particle.restart()
