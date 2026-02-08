class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var rotate_speed: float

@export_subgroup("Horizontal")
@export var max_rotation_speed: float
@export var rotation_speed_acc: float
@export var rotation_speed_dec: float

@export_subgroup("Boost")
@export var boost_speed: float
@export var max_boost_speed: float

@export_subgroup("Gravity")
@export var gravity: float
@export var gravity_limit: float

@onready var shape: Node2D = $Shape as Node2D
@onready var boost_timer: Timer = %BoostTimer as Timer
@onready var state_machine: StateMachine = $StateMachine as StateMachine

func _ready() -> void:
	var hud: HUD = Global.get_hud()
	
	if hud:
		hud.oxygen_reduce_timer.start()
		hud.oxygen_finished.connect(_on_oxygen_finished)

func get_input_dir() -> float:
	return Input.get_axis("left", "right")

func apply_movement() -> void:
	rotation_degrees += rotate_speed * get_input_dir()
	
	var clamped_rotation: float = pingpong(rotation_degrees + 90.0, 180.0) - 90.0
	var target_speed: float = remap(clamped_rotation, -90.0, 90.0, -max_rotation_speed, max_rotation_speed)
	
	var is_acc: bool = signf(target_speed - velocity.x) == signf(target_speed)
	var step: float = rotation_speed_acc if is_acc else rotation_speed_dec
	
	velocity.x = move_toward(velocity.x, target_speed, step)

func apply_gravity() -> void:
	velocity.y = move_toward(velocity.y, gravity_limit, gravity)

func apply_boost() -> void:
	var delta_velocity: Vector2 = boost_speed * Vector2.UP.rotated(rotation)
	
	velocity += delta_velocity
	
	if velocity.length() > max_boost_speed:
		velocity = velocity.normalized() * max_boost_speed

func try_boost() -> void:
	if Input.is_action_just_pressed("boost") and boost_timer.is_stopped():
		apply_boost()
		boost_timer.start()

func round_values() -> void:
	velocity = velocity.round()
	rotation_degrees = roundf(rotation_degrees)

func update_flip_h() -> void:
	var margin: float = 0.1
	shape.scale.x = 1.0 if rotation_degrees >= 0.0 or rotation_degrees < -180.0 + margin else -1.0

func kill() -> void:
	state_machine.activate_state_by_name.call_deferred("DeathState")

func _on_oxygen_finished() -> void:
	kill()
