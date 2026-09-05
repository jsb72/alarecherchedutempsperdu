extends Node2D
@onready var timer: Timer = $Timer

@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var shootaudio: AudioStreamPlayer2D = $shootaudio
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

@export var timing:float=1.0
@export var randomizing:bool=true
@export var speed:int=1800

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time=timing


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@onready var bomblist: Node2D = $"../bomblist"
func shoot():
	
	animation_player.play("new_animation")
	shootaudio.play()
	await get_tree().create_timer(0.05).timeout
	
	gpu_particles_2d.restart()
	
	var bombspawedpacked = load("res://src/elements/bomb.tscn")
	var bombspawed = bombspawedpacked.instantiate()
	
	bombspawed.global_position=global_position
	#bombspawed.global_position.y+=16
	
	bomblist.add_child(bombspawed)
	
	var tir_vector = Vector2(-speed,0)
	tir_vector=tir_vector.rotated(self.rotation)
	bombspawed.linear_velocity = tir_vector

	
		


func _on_timer_timeout() -> void:
	shoot()
	
	if randomizing:
		var new_time = snapped(randfn(0.1, 1.0),0.1)
		#print(timer.wait_time)
		timer.wait_time=new_time
	
	timer.start()
