class_name PlayerDashState
extends PlayerState

var start_point: Vector2 = Vector2.ZERO

func _enter(_previous_state: State) -> void:
	player.dash_particles.emitting = true
	Global.Camera.apply_shake(player.dash_camera_shake_strength, player.dash_camera_shake_fade)
	Global.Camera.apply_zoom(player.dash_camera_zoom_value, player.dash_camera_zoom_fade)
	start_point = player.global_position
	
	var hud: HUD = Global.UI.get_hud()
	
	if hud:
		hud.oxygen -= player.dash_oxygen_reduce_amount

func _exit(_current_state: State) -> void:
	player.dash_particles.emitting = false
	player.dash_timer.start()
	player.velocity *= player.after_dash_velocity_ratio

func _physics_update(_delta: float) -> void:
	apply_dash()
	player.round_values()
	
	player.apply_animations()
	player.move_and_slide()
	
	if player.global_position.distance_to(start_point) >= player.dash_distance or player.get_slide_collision_count() > 0:
		switch_to("ControlState")

func apply_dash() -> void:
	player.velocity = player.dash_speed * Vector2.UP.rotated(player.rotation)
