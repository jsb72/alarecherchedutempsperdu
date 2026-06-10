extends Node2D

@onready var eye : Sprite2D = get_node("eye")
@onready var pupil : Sprite2D = get_node("eye/pupil")

@onready var player: Player = get_node("/root/VHS/room_blueprint/Player")



@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer


const skew_limit = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func track_eye(eye : Node2D):
	var center = eye.global_position
	var pupil : Node2D = eye.get_child(0)
	#get_local_mouse_position()
	var player_pos = player.global_position
	var direction : Vector2 = (player_pos - center)
	var distance = direction.length()
	
	
	var limit = 40
	
	direction = direction.normalized()
	var offset = direction * (min(distance, limit))
	
	pupil.position = offset
	

func _process(time):
	if player !=null:
		track_eye($eye)
	
	var random = RandomNumberGenerator.new()
	if randi_range(0, 256)==0:
		pass
		#animation_player.play("new_animation")
