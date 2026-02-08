class_name HammerheadSharkAttackState
extends HammerheadSharkState

var start_point: Vector2 = Vector2.ZERO

func _enter(_previous_state: State) -> void:
	start_point = shark.global_position

func _physics_update(delta: float) -> void:
	apply_dash()
	shark.round_values()
	
	shark.move(delta)
	
	if shark.global_position.distance_to(start_point) >= shark.dash_distance:
		switch_to("ChaseState")

func apply_dash() -> void:
	shark.velocity = shark.dash_speed * Vector2.RIGHT.rotated(shark.rotation)

func _on_hammerhead_shark_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player.kill()
