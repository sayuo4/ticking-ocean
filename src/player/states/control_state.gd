class_name PlayerControlState
extends PlayerState

func _physics_update(_delta: float) -> void:
	player.apply_movement()
	player.apply_gravity()
	player.try_boost()
	player.try_dash()
	player.round_values()
	player.update_flip_h()
	player.apply_animations()
	
	player.move_and_slide()
