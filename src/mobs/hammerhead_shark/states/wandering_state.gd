class_name HammerheadSharkWanderingState
extends HammerheadSharkState

var target_point: Vector2 = Vector2.ZERO

func _enter(_previous_state: State) -> void:
	randomize_point()
	shark.reached_point.connect(randomize_point)

func _physics_update(delta: float) -> void:
	shark.move_to_point(target_point, shark.wandering_rotate_speed, shark.wandering_swim_speed, shark.wandering_acc)
	shark.round_values()
	shark.update_flip_h()
	
	shark.move(delta)

func randomize_point() -> void:
	var points_count: int = shark.wandering_points.size()
	
	if not points_count:
		return
	
	var point: Marker2D = shark.wandering_points[randi_range(0, points_count - 1)]
	
	if point:
		target_point = point.global_position

func _on_detect_player_area_body_entered(body: Node2D) -> void:
	if body is Player:
		switch_to("ChaseState")
