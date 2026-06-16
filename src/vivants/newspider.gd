extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $spiderrendu/AnimatedSprite2D
@onready var spiderrendu: Node2D = $spiderrendu
@onready var vray: RayCast2D = $spiderrendu/vray
@onready var hray: RayCast2D = $spiderrendu/hray
@onready var antihumanhray: RayCast2D = $spiderrendu/antihumanhray

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var speed_move:float = 0.4
var dead:bool=false

@export var angle_spiderrendu:int=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spiderrendu.rotation_degrees=angle_spiderrendu

func _process(delta: float) -> void:
	if !dead:
		if antihumanhray.is_colliding():
			var collidobj = antihumanhray.get_collider()
			if collidobj is Player :
				spiderrendu.scale.x*=-1
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !dead:
		if getCollisionSurface(hray):
			if spiderrendu.scale.x==1:
				spiderrendu.rotation_degrees=spiderrendu.rotation_degrees-90
			if spiderrendu.scale.x==-1:
				spiderrendu.rotation_degrees=spiderrendu.rotation_degrees+90
		if !getCollisionSurface(vray):
			spiderrendu.scale.x*=-1
			if spiderrendu.scale.x==-1:
				spiderrendu.rotation_degrees=360+spiderrendu.rotation_degrees
			if spiderrendu.scale.x==1:
				spiderrendu.rotation_degrees=-spiderrendu.rotation_degrees
			
		if spiderrendu.rotation_degrees==-360 or spiderrendu.rotation_degrees==360:
			spiderrendu.rotation_degrees=0
			
		if spiderrendu.scale.x==1:
			if spiderrendu.rotation_degrees==0:
				global_position.x+=speed_move
			if spiderrendu.rotation_degrees==-90:
				global_position.y-=speed_move
			if spiderrendu.rotation_degrees==-180:
				global_position.x-=speed_move
			if spiderrendu.rotation_degrees==-270:
				global_position.y+=speed_move
				
				
		if spiderrendu.scale.x==-1:
			if spiderrendu.rotation_degrees==0:
				global_position.x-=speed_move
			if spiderrendu.rotation_degrees==90:
				global_position.y-=speed_move
			if spiderrendu.rotation_degrees==180:
				global_position.x+=speed_move
			if spiderrendu.rotation_degrees==270:
				global_position.y+=speed_move
				
			
		animated_sprite_2d.play("walk")
	
func getCollisionSurface(rcast:RayCast2D):
	if rcast.is_colliding():
		var collidobj = rcast.get_collider()
		if collidobj is TileMapLayer :
			return collidobj
	return null


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		if !dead:
			dead=true
			animated_sprite_2d.play("death")
			audio_stream_player_2d.play()
