extends Node2D
@onready var player: Player = %Player

@onready var zoomcam: PhantomCamera2D = $zoomcam
@onready var cam: PhantomCamera2D = %cam
@onready var cam_2: PhantomCamera2D = %cam2
@onready var camoffesetbottom: PhantomCamera2D = $camoffesetbottom
@onready var camoffesetbottom_2: PhantomCamera2D = %camoffesetbottom2

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


@onready var lvl_1: Node2D = $lvl1
@onready var lvl_2: Node2D = $lvl2

var lvl_2_loaded:bool = false

@onready var black_particule: Node2D = $"lvl1/black particule"
@onready var sage_2: Node2D = $lvl1/sage2

func _ready() -> void:
		
	player.dead_ = true
	
	#display_list_cadavre()
	
	#creer_ground()
	
	lvl_2.hide()
	lvl_2.process_mode = Node.PROCESS_MODE_DISABLED
	
	if !Global.debug_mod:
		player.process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer(6).timeout
		player.process_mode = Node.PROCESS_MODE_INHERIT

	
@onready var color_rect_fog: ColorRect = $red_plafond/ColorRectFOG
var first_time_on_floor:bool=true		
func _process(delta: float) -> void:
	optimization_logic()
	
	if player.global_position.y > -3775:
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect_fog, "modulate:a", 0.0, 1.0)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(color_rect_fog, "modulate:a", 1.0, 1.0)
	
	if player.global_position.y > -700 and first_time_on_floor:
		first_time_on_floor=false
		player.dead_ = false
		var tween = get_tree().create_tween()
		tween.tween_property(player.point_light_2d, "energy", 1.0, 10.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "energy", 1.0, 10.0)
	
		
	if player.global_position.y > 200:
		cam.limit_right = 28350
		cam_2.limit_right = 28350
	else:
		cam.limit_right = 18722
		cam_2.limit_right = 18722

	if !first_time_on_floor:ambiance_logic()
	void_logic()
	
	
	if player.global_position.y > 13000:
		Global.first_cycle_done=true
		#get_tree().change_scene_to_file("res://src/accueil.tscn")
		get_tree().reload_current_scene()
		
	
	


#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS#FONCTIONS
@onready var hugetentacles: Node2D = $lvl5/hugetentacles
@onready var tentacles_void: Node2D = $void/tentacles
@onready var yog_sothoth: Node2D = $"Yog-Sothoth"
func optimization_logic()->void:
	if player.global_position.y < 8888:
		hugetentacles.process_mode=Node.PROCESS_MODE_DISABLED
	else:
		hugetentacles.process_mode=Node.PROCESS_MODE_INHERIT
		Engine.time_scale=0.7
		
	if player.global_position.x >-4600 and player.global_position.x < -2500:
		tentacles_void.process_mode=Node.PROCESS_MODE_INHERIT
		tentacles_void.show()
	else:
		tentacles_void.process_mode=Node.PROCESS_MODE_DISABLED
		tentacles_void.hide()
		
	"""if player.global_position.x >22000 and player.global_position.y < 2400:
		yog_sothoth.process_mode=Node.PROCESS_MODE_INHERIT
		yog_sothoth.show()
	else:
		yog_sothoth.process_mode=Node.PROCESS_MODE_DISABLED
		yog_sothoth.hide()"""
	

@onready var surface: Area2D = $AMBIANCE_ZONE/surface
@onready var matrice: Area2D = $AMBIANCE_ZONE/matrice
@onready var floral: Area2D = $AMBIANCE_ZONE/floral
@onready var complot: Area2D = $AMBIANCE_ZONE/complot
var surface_music1_already_played:bool=false
func ambiance_logic():
	
	var ambiance_zone_actuelle:String="vide"
	if surface.overlaps_body(player) and !lvl_2_loaded:
		if !surface_music1_already_played:
			ambiance_zone_actuelle="surface"
		else:
			ambiance_zone_actuelle="surface2"
	else:
		surface_music1_already_played=true
	if floral.overlaps_body(player):
		ambiance_zone_actuelle="floral"
	if complot.overlaps_body(player) and lvl_2_loaded:
		ambiance_zone_actuelle="complot"
	if matrice.overlaps_body(player):
		ambiance_zone_actuelle="matrice"

	if !audio_stream_player.playing:
		audio_stream_player.play()
	var playing_clip_name = audio_stream_player.stream.get_clip_name(audio_stream_player.get_stream_playback().get_current_clip_index())
	if playing_clip_name !=ambiance_zone_actuelle:
		audio_stream_player.get_stream_playback().switch_to_clip_by_name(ambiance_zone_actuelle)
		audio_stream_player.volume_db=-10.0	
		
	if ambiance_zone_actuelle=="surface":		
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color("9e9e9eff"), 3.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "color", Color(0.0, 0.0, 0.0, 1.0), 1.0)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(player.point_light_2d, "color", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		
	if ambiance_zone_actuelle=="floral":		
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color("6459deff"), 3.0)#dbfff4ff
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "color", Color(0.0, 0.967, 1.0, 1.0), 1.0)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(player.point_light_2d, "color", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		
	if ambiance_zone_actuelle=="complot":		
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color("919191ff"), 3.0)#ffc7c7ff
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "color", Color("ffffffff"), 1.0)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(player.point_light_2d, "color", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		
	if ambiance_zone_actuelle=="matrice":	
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color("ffffffff"), 3.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "color", Color(1.0, 0.0, 0.0, 1.0), 1.0)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(player.point_light_2d, "color", Color(0.43, 0.43, 0.43, 1.0), 1.0)
		
	if ambiance_zone_actuelle=="vide":		
		var tween = get_tree().create_tween()
		tween.tween_property(canvas_modulate, "color", Color("ffffffff"), 3.0)
		var tween2 = get_tree().create_tween()
		tween2.tween_property(player.point_light_2d_2, "color", Color(1.0, 1.0, 1.0, 1.0), 1.0)
		var tween3 = get_tree().create_tween()
		tween3.tween_property(player.point_light_2d, "color", Color(0.77, 0.77, 0.77, 1.0), 1.0)
		
		
		
func display_list_cadavre():
	for cadavre_elem in Global.list_des_morts:
		var cad = player.cadavre.duplicate()
		cad.global_position = cadavre_elem
		cad.global_position.y -= 36
		cad.visible=true
		$".".add_child(cad)  

@onready var ground: Sprite2D = $lvl1/ground
@onready var surfaceblackparticle: Node2D = $lvl1/surfaceblackparticle
func duplicate_ground(offset_x):
	var r = ground.duplicate()
	r.position.x = r.position.x + offset_x 
	r.z_index = r.z_index -1
	$".".add_child(r)  
func duplicate_surfaceblackparticle(offset_x):
	var r = surfaceblackparticle.duplicate()
	r.position.x = r.position.x + offset_x 
	$".".add_child(r)  
func creer_ground():
	var len = 0.274 * 13902
	for i in range(10):
		duplicate_ground(i*len)
	ground.hide()
	ground.process_mode = Node.PROCESS_MODE_DISABLED		
	
	var width = 1406
	for i in range(1,12):
		duplicate_surfaceblackparticle(-i*width)
	
@onready var static_body_2d: StaticBody2D = $void/StaticBody2D	
@onready var univers: Sprite2D = $void/yeux/univers
@onready var pop_eye_timer: Timer = $void/pop_eye_timer
@onready var yeux: Node2D = $void/yeux

func void_logic():
	if player.global_position.x < -4318:
		static_body_2d.set_deferred("process_mode",Node.PROCESS_MODE_INHERIT)
	else:
		static_body_2d.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
	
	var limit = - 5555
	if player.global_position.x < limit and player.global_position.y < 1000:
		var diff = limit - player.global_position.x
		diff = diff/1000
		
		if chapitre_2_lvl_1.visible:
			if player.global_position.x < -909084864.0:
				player.dead_=true
			Engine.time_scale = 1 + diff
			player.glitch_rect.visible=true
			if pop_eye_timer.is_stopped():
				
				var new_uni = univers.duplicate()
				var newscale=randf_range(0.005, 0.15)
				new_uni.scale=Vector2(newscale,newscale)
				new_uni.global_position = player.global_position + Vector2(randi_range(-640, 640),randi_range(-360-160, 360-160))
				new_uni.global_position+=Vector2(9500,500)
				yeux.add_child(new_uni)  
				pop_eye_timer.start()
				
		else:
			if diff >0.9:
				diff = 0.9
			Engine.time_scale = 1 - diff



#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC#CAMERA LOGIC
func _on_zoom_zone_body_entered(body: Node2D) -> void:
	if body is Player : zoomcam.priority = 10
func _on_zoom_zone_body_exited(body: Node2D) -> void:
	if body is Player : zoomcam.priority = 0
func _on_no_bottom_offset_zone_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player : camoffesetbottom.priority = 10
func _on_no_bottom_offset_zone_body_exited(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player : 
			camoffesetbottom.priority = 0
			camoffesetbottom_2.priority = 0

func _on_no_offset_zone_lvl_2_body_entered(body: Node2D) -> void:
	if body is Player : camoffesetbottom.priority = 10
func _on_no_offset_zone_lvl_2_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0

func _on_camzoneoffset_lvl_5_body_entered(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 10
		"""camoffesetbottom.follow_offset.y=250
		camoffesetbottom_2.follow_offset.y=250"""
func _on_camzoneoffset_lvl_5_body_exited(body: Node2D) -> void:
	if body is Player : 
		camoffesetbottom.priority = 0
		camoffesetbottom_2.priority = 0
		
		

#CHANGE SCENE#CHANGE SCENE#CHANGE SCENE#CHANGE SCENE#CHANGE SCENE#CHANGE SCENE#CHANGE SCENE
@onready var findumonde: Label = $findumonde
func _on_change_scene_whenvoid_body_entered(body: Node2D) -> void:
	if body is Player:
		if !lvl_2_loaded:
			lvl_1.hide()
			lvl_1.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
			#lvl_1.process_mode = Node.PROCESS_MODE_DISABLED
			lvl_2.show()
			lvl_2.process_mode = Node.PROCESS_MODE_INHERIT
			
			black_particule.layer1.hide()
			black_particule.layer2.hide()
			black_particule.layer3.hide()
			
			lvl_2_loaded = true
			findumonde.hide()
			
		body.glitch_rect.visible=true
		await get_tree().create_timer(2).timeout
		body.glitch_rect.visible=false
		
func _on_change_scene_zone_body_entered(body: Node2D) -> void:
	if body is Player:
		if !lvl_2_loaded:
			lvl_1.hide()
			lvl_1.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
			#lvl_1.process_mode = Node.PROCESS_MODE_DISABLED
			lvl_2.show()
			lvl_2.process_mode = Node.PROCESS_MODE_INHERIT
			
			black_particule.layer1.hide()
			black_particule.layer2.hide()
			black_particule.layer3.hide()
			
			lvl_2_loaded = true
			findumonde.hide()
func _on_change_scene_zone_2_lvl_3_body_entered(body: Node2D) -> void:
	if body is Player:
		if lvl_2_loaded:
			lvl_1.show()
			lvl_1.process_mode = Node.PROCESS_MODE_INHERIT
			lvl_2.hide()
			lvl_2.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
			#lvl_2.process_mode = Node.PROCESS_MODE_DISABLED
			
			
			black_particule.layer1.show()
			black_particule.layer2.show()
			black_particule.layer3.show()
			
			lvl_2_loaded = false
			findumonde.show()

@onready var chapitre_2_lvl_1: Node2D = $chapitre2lvl1
func _on_loadchap_2_lvl_1_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			chapitre_2_lvl_1.show()
			chapitre_2_lvl_1.process_mode = Node.PROCESS_MODE_INHERIT			
			
			cam.limit_left = -922337203
			cam_2.limit_left = -922337203
			cam.draw_limits=false
			cam_2.draw_limits=false
func _on_unloadchap_2_lvl_1_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			chapitre_2_lvl_1.hide()
			chapitre_2_lvl_1.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)

func _on_unloadlvl_1_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			lvl_1.hide()
			lvl_1.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)

func _on_loadlvl_1_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			lvl_1.show()
			lvl_1.process_mode = Node.PROCESS_MODE_INHERIT



#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE#DEATHZONE
func _on_deathzone_body_entered(body: Node2D) -> void:
	if body is Player:
		player.respawn()
		
		
		
#HIDE PLAYER ZONE#HIDE PLAYER ZONE#HIDE PLAYER ZONE#HIDE PLAYER ZONE#HIDE PLAYER ZONE#HIDE PLAYER ZONE#HIDE PLAYER ZONE
@onready var trailplayer: Node2D = $trailplayer
func _on_novisibleplayerzone_body_entered(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			var tween = get_tree().create_tween()
			tween.tween_property(body, "modulate:a", 0.0, 0.1)
			trailplayer.hide()
func _on_novisibleplayerzone_body_exited(body: Node2D) -> void:
	if !lvl_2_loaded:
		if body is Player:
			var tween = get_tree().create_tween()
			tween.tween_property(body, "modulate:a", 1.0, 0.1)
			trailplayer.show()



#CHECKPOINTS
func _on_checkpoints_body_entered(body: Node2D) -> void:
	if body is Player:
		body.last_floor_pos=body.global_position
