extends Node2D

@onready var laser_trap_2: Node2D = $laser_trap3
@onready var laser_trap_3: Node2D = $laser_trap6
@onready var laser_trap_4: Node2D = $laser_trap4
@onready var laser_trap_5: Node2D = $laser_trap5
@onready var laser_trap_6: Node2D = $laser_trap2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_body_entered_escalier(body: Node2D) -> void:
	if body is Player:
		laser_trap_2.disable_laser()
		laser_trap_3.disable_laser()
		laser_trap_4.disable_laser()
		laser_trap_5.disable_laser()
		laser_trap_6.disable_laser()
