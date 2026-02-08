class_name SawBlade
extends Area2D

@export var spin_speed: float
@export var move_speed: float
@export var move_acc: float
@export var reached_point_distance: float
@export var move_points: Array[Marker2D]

var velocity: Vector2 = Vector2.ZERO
var target_point: int = 0: set = set_target_point

func _physics_process(delta: float) -> void:
	apply_movement(delta)

func apply_movement(delta: float) -> void:
	global_rotation_degrees += spin_speed
	
	if not move_points.size():
		return
	
	var target_marker: Marker2D = move_points[target_point]
	
	if not target_marker:
		return
	
	var target_position: Vector2 = target_marker.global_position
	var direction: Vector2 = (target_position - global_position).normalized()
	var target_velocity: Vector2 = direction * move_speed
	velocity = velocity.move_toward(target_velocity, move_acc)
	
	if global_position.distance_to(target_position) <= reached_point_distance:
		target_point += 1
	
	global_position += velocity * delta

func set_target_point(value: int) -> void:
	target_point = wrapi(value, 0, move_points.size())

func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player.kill()
