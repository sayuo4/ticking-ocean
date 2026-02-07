class_name HammerheadSharkChaseState
extends HammerheadSharkState

func _physics_update(delta: float) -> void:
	shark.move_to_point(get_player_position(), shark.chasing_rotate_speed, shark.chasing_swim_speed, shark.chasing_acc)
	shark.round_values()
	shark.update_flip_h()
	
	shark.move(delta)

func get_player_position() -> Vector2:
	var player: Player = shark.get_player()
	
	if not player:
		return Vector2.ZERO
	
	return player.global_position

func _on_start_attack_area_body_entered(body: Node2D) -> void:
	if body is Player:
		switch_to("AttackState")
