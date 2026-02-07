class_name HammerheadSharkMoveAroundState
extends HammerheadSharkState

var target_point: Vector2 = Vector2.ZERO: get = get_target_point

func _enter(_previous_state: State) -> void:
	update_target_point()
	shark.reached_point.connect(update_target_point)

func _physics_update(delta: float) -> void:
	shark.move_to_point(target_point)
	shark.update_flip_h()
	
	shark.move(delta)

func update_target_point() -> void:
	var player: Player = shark.get_player()
	
	if not player:
		return
	
	if player.global_position.x > shark.global_position.x:
		target_point = Vector2(-shark.follow_player_range, shark.follow_player_range)
	else:
		target_point = Vector2(shark.follow_player_range, -shark.follow_player_range)

func get_target_point() -> Vector2:
	var player: Player = shark.get_player()
	
	if not player:
		return target_point
	
	return player.global_position + target_point
