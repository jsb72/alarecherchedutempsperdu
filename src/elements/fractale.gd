extends RigidBody2D

@onready var touchedsong: AudioStreamPlayer2D = $touchedsong
@onready var animation_player: AnimationPlayer = $Sprite2D/AnimationPlayer

@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@export var identifiant:int

var touched = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Global.fractal_list[identifiant]:
		queue_free()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and !touched:
		touched = true
		touchedsong.play()
		animation_player.play("disapear")
		
		body.shakecamtimer.start()
		
		set_deferred("freeze", true)
		collision_polygon_2d.set_deferred("disabled", true)



func _on_touchedsong_finished() -> void:
	Global.fractal_list[identifiant]=false
	Global.nb_fractal +=1
