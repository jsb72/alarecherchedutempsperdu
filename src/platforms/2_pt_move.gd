extends Node2D

@onready var animation_player: AnimationPlayer = $pts/platform2/AnimationPlayer
@onready var animation_player2: AnimationPlayer = $pts/platform/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		animation_player.play("1")
		animation_player2.play("2")


func _on_area_2d_body_exited(body: Node2D) -> void:
	pass
