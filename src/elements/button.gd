extends Node2D

@onready var animation_player: AnimationPlayer = $Sprite2D2/AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var infinite_press : bool = false

var pushed : bool = false


@export var gold_color : bool = false
@onready var gold: Sprite2D = $gold
@onready var goldtop: Sprite2D = $goldtop
@onready var animation_playergold: AnimationPlayer = $goldtop/AnimationPlayer
@onready var point_light_2d: PointLight2D = $PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if gold_color :
		gold.show()
		goldtop.show()
		#point_light_2d.hide()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if !pushed :
			animation_player.play("new_animation")
			if gold_color:
				animation_playergold.play("new_animation")
			audio_stream_player_2d.play()
			pushed = true


func _on_body_exited(body: Node2D) -> void:
	if infinite_press :
		animation_player.play("new_animation_reverse")
		pushed = false
