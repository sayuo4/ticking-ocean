extends CharacterBody2D
class_name Jellyfish




## the force done on the jellyfish when pushing itself.
@export var push_force: float = 80.0

@export_group("movement")
@export_subgroup("speed")
## the speed when the jelly is wandering around.
@export var partrol_speed: float = 100.0
@export var chase_speed: float = 100.0
## the speed when the jelly is chasing the player.s
@export var chasing_speed: float = 100.0

@export_subgroup("acceleration")
## the acceleration of the jellyfish during patrol state.
@export var patrol_acc: float = 200.0 
## the acceleration of the jellyfish during chase state.
@export var chase_acc: float = 200.0 
@export_subgroup("acceleration")
## the acceleration of the jellyfish during patrol state.
@export var patrol_decel: float = 200.0 
## the acceleration of the jellyfish during chase state.
@export var chase_decel: float = 200.0 

@export_group("radii")
## the radius the target position will be set to relative the position of the jelly fish.
@export var patrol_radius: float = 120.0
## if you (the player) enter this radius, the jellyfish will chase you.
@export var vision_radius: float = 90.0

@export_group("distances")
## the distance from the target position where the jelly is considered arrived at the point.
@export var patrol_arriving_distance: float = 5.0
## the distance from the target position where the jelly is considered arrived at the player.
@export var chasing_arriving_distance: float = 6.0

@export_group("deperecated")
## the points the jelly fish will move along.
##@deprecated: forget this idea for now.
@export var patrol_positions: Array[Vector2] = []:
	set(value):
		patrol_positions = value
		queue_redraw()



## the velocity of the push effect, handeled seperatley to get an accurate behaviour.
var added_velocity: Vector2 = Vector2.ZERO




## called by the animaiton player to give the jelly a push in the animation.
func push() -> void:
	added_velocity += velocity.normalized() * (
		push_force if !arrived_at_point(get_player_position(), chasing_arriving_distance) else 0.0
	)



## accelerates towards [param towards]
func accelerate(towards: Vector2) -> void:
	velocity = velocity.move_toward(
		towards + added_velocity,
		get_acc()
	)
	added_velocity = added_velocity.lerp(Vector2.ZERO, 0.1)
	move_and_slide()


## accelerates towards [param towards]
func decelerate() -> void:
	velocity = velocity.move_toward(
		Vector2.ZERO,
		get_decel()
	)
	added_velocity = added_velocity.lerp(Vector2.ZERO, 0.1)
	move_and_slide()


func get_acc() -> float:
	return chase_acc if is_chasing() else patrol_acc



func get_decel() -> float:
	return chase_decel if is_chasing() else patrol_decel

func is_chasing() -> bool:
	return %StateMachine.active_state == %ChasingPlayer

## returns the random pos inside the [memebr patrol_radius].
func choose_target_pos() -> Vector2:
	var theta := deg_to_rad(randf_range(0.0, 360.0))
	var pos := Vector2(randf_range(0.0, patrol_radius), 0.0)
	return pos.rotated(theta)
	

## see [member arriving_distance]
## [param point] is a global coordinates.
func arrived_at_point(point: Vector2, arriving_distance: float = patrol_arriving_distance) -> bool:
	return global_position.distance_to(point) <= arriving_distance


## returns the player position.
func get_player_position() -> Vector2:
	var player: Player = Global.get_player()
	
	if not player:
		return Vector2.ZERO
	
	return player.global_position


func get_distance_to_player() -> float:
	return global_position.distance_to(get_player_position())

func is_player_in_vision_range() -> bool:
	return get_distance_to_player() <= vision_radius


func _on_hitbox_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player.kill()
