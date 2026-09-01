extends Node2D
@onready var timer: Timer = $Timer

@onready var animation_player: AnimationPlayer = $Node2D/AnimationPlayer
@onready var shootaudio: AudioStreamPlayer2D = $shootaudio
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
	
	bombspawed.linear_velocity=Vector2(-1800,0)
	
		


func _on_timer_timeout() -> void:
	shoot()
	
	var new_time = snapped(randfn(0.1, 1.0),0.1)
	#print(timer.wait_time)
	timer.wait_time=new_time
	
	timer.start()
