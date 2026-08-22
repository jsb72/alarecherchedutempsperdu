extends Node2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var cam: PhantomCamera2D = $"../cam"

@export var door_id:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if (Global.list_door[door_id])["opened"]:static_body_2d.global_position.y+=-300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(Global.list_door[door_id])["opened"]:
		(Global.list_door[door_id])["opened"]=true
		
		body.unlock_door()
		
		await get_tree().create_timer(0.5).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(static_body_2d, "global_position:y", static_body_2d.global_position.y-300, 5)


func _on_triggernextlvl_body_entered(body: Node2D) -> void:
	Fadetoblack.transition(7)
	await Fadetoblack.on_transition_finished
	
	Global["next_door_id"]=(Global.list_door[door_id])["door_id_target"]
	var next_lvl_name = (Global.list_door[Global["next_door_id"]])["lvl_name"]
	get_tree().change_scene_to_file("res://src/network/scenes/"+next_lvl_name+".tscn")


func _on_limit_cam_zone_body_entered(body: Node2D) -> void:
	if (Global.list_door[door_id])["flip_h"]:
		cam.set_limit_right((Global.list_door[door_id])["pos"].x+128)
	else:
		cam.set_limit_left((Global.list_door[door_id])["pos"].x-128)


func _on_limit_cam_zone_body_exited(body: Node2D) -> void:
	cam.set_limit_left(-10000)
	cam.set_limit_right(10000)
