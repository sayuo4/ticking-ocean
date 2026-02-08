class_name PlayerDashState
extends PlayerState

var start_point: Vector2 = Vector2.ZERO

func _enter(_previous_state: State) -> void:
	start_point = player.global_position
	
	var hud: HUD = Global.get_hud()
	
	if hud:
		hud.oxygen -= player.dash_oxygen_reduce_amount

func _exit(_current_state: State) -> void:
	player.dash_timer.start()
	player.velocity *= player.after_dash_velocity_ratio

func _physics_update(_delta: float) -> void:
	apply_dash()
	player.round_values()
	
	player.move_and_slide()
	
	if player.global_position.distance_to(start_point) >= player.dash_distance or player.get_slide_collision_count() > 0:
		switch_to("ControlState")

func apply_dash() -> void:
	player.velocity = player.dash_speed * Vector2.UP.rotated(player.rotation)
