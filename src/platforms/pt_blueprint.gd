class_name Ptblueprint
extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	sprite_2d.modulate = Color.from_hsv(0.0, 0.0, randf_range(0.1, 1.0), 1.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
