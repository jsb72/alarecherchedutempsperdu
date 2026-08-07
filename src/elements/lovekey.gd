extends RigidBody2D

@onready var pin_joint_2d: PinJoint2D = $PinJoint2D

@onready var sprite_2d_2: Sprite2D = $Sprite2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	

func _on_area_2d_body_entered(body: Node2D) -> void:
	pin_joint_2d.node_a=self.get_path()
	pin_joint_2d.node_b=body.get_path()

func unlock_door()->void:
	var tween3 = get_tree().create_tween()
	tween3.tween_property(sprite_2d_2, "modulate:a", 0.0, 2.0)
	
	await get_tree().create_timer(2).timeout
	
	self.queue_free()
