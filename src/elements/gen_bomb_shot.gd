extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


@onready var bomblist: Node2D = $"../bomblist"
func shoot():
	var bombspawedpacked = load("res://src/elements/bomb.tscn")
	var bombspawed = bombspawedpacked.instantiate()
	
	bombspawed.global_position=global_position
	bombspawed.global_position.y+=16
	
	bomblist.add_child(bombspawed)
	
	bombspawed.linear_velocity=Vector2(-1500,0)
		


func _on_timer_timeout() -> void:
	shoot()
