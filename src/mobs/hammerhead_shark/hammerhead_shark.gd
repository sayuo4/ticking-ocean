class_name HammerheadShark
extends Area2D

signal reached_point

@export var wandering_points: Array[Marker2D]
@export var switch_values_delta: float

@export_group("Movement")
@export_subgroup("Wandering")
@export var wandering_rotate_speed: float
@export var wandering_swim_speed: float
@export var wandering_acc: float
@export var reached_point_range: float

@export_subgroup("Chasing")
@export var chasing_rotate_speed: float
@export var chasing_swim_speed: float
@export var chasing_acc: float

@export_subgroup("Attack")
@export var dash_speed: float
@export var dash_distance: float

var velocity: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D

func move(delta: float) -> void:
	global_position += velocity * delta

func move_to_point(point: Vector2, rotate_speed: float, swim_speed: float, acc: float) -> void:
	var angle_to_point: float = rad_to_deg(get_angle_to(point))
	rotation_degrees = move_toward(rotation_degrees, rotation_degrees + angle_to_point, rotate_speed)
	
	var target_velocity: Vector2 = swim_speed * Vector2.RIGHT.rotated(rotation)
	velocity = velocity.move_toward(target_velocity, acc)
	
	if global_position.distance_to(point) <= reached_point_range:
		reached_point.emit()

func update_flip_h() -> void:
	sprite.flip_v = velocity.x <= 0

func get_player() -> Player:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	
	return player

func round_values() -> void:
	velocity = velocity.round()
	rotation_degrees = roundf(rotation_degrees)
