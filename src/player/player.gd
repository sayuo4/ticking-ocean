class_name Player
extends CharacterBody2D

const SWIM_ANIM: StringName = &"swim"
const IDLE_ANIM: StringName = &"idle"

@export var start_oxygen_time: float

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

@export_subgroup("Bounce")
@export var bounce_of_wall_force: Vector2
@export var after_bounce_acc: float

@export_group("Dash")
@export var dash_speed: float
@export var dash_distance: float
@export var dash_oxygen_reduce_amount: float
@export var after_dash_velocity_ratio: float

@export_group("Animation")
@export var fade_time: float
@export var after_fade_time: float
@export var swimming_speed_threshhold: float
@export var max_sand_particles_amount: int

@export_group("Camera")
@export var death_camera_shake_strength: float
@export var death_camera_shake_fade: float

@export var dash_camera_shake_strength: float
@export var dash_camera_shake_fade: float

@export var dash_camera_zoom_value: Vector2 = Vector2.ONE
@export var dash_camera_zoom_fade: float

@onready var shape: Node2D = $Shape as Node2D
@onready var state_machine: StateMachine = $StateMachine as StateMachine
@onready var sprite: Sprite2D = %Sprite2D as Sprite2D

@onready var boost_timer: Timer = %BoostTimer as Timer
@onready var dash_timer: Timer = %DashTimer as Timer
@onready var bounce_timer: Timer = %BounceTimer as Timer

func _ready() -> void:
	Global.enable_pause_menu()
	await get_tree().create_timer(start_oxygen_time).timeout
	Global.start_oxygen_timer(_on_oxygen_finished)

func get_input_dir() -> float:
	return Input.get_axis("left", "right")

func apply_movement() -> void:
	rotation_degrees += rotate_speed * get_input_dir()
	
	var clamped_rotation: float = pingpong(rotation_degrees + 90.0, 180.0) - 90.0
	var target_speed: float = remap(clamped_rotation, -90.0, 90.0, -max_rotation_speed, max_rotation_speed)
	
	var is_acc: bool = signf(target_speed - velocity.x) == signf(target_speed)
	
	var step: float = (
			after_bounce_acc if not bounce_timer.is_stopped()
			else rotation_speed_acc if is_acc else rotation_speed_dec
	)
	
	velocity.x = move_toward(velocity.x, target_speed, step)

func apply_gravity() -> void:
	velocity.y = move_toward(velocity.y, gravity_limit, gravity)

func apply_boost() -> void:
	var delta_velocity: Vector2 = boost_speed * Vector2.UP.rotated(rotation)
	
	velocity += delta_velocity
	
	if velocity.length() > max_boost_speed:
		velocity = velocity.normalized() * max_boost_speed

func apply_animations() -> void:
	if velocity.length() < swimming_speed_threshhold:
		if %Anim.current_animation == SWIM_ANIM: # wait the swim anim to finish
			wait_for_swim_anim()
			return
		
		%Anim.play(IDLE_ANIM)
	else:
		%Anim.play(SWIM_ANIM, 0.1)

func wait_for_swim_anim() -> void:
	var animation_end: float = %Anim.current_animation_length - 0.2
	if %Anim.current_animation_position > animation_end:
		%Anim.play(IDLE_ANIM)

func try_boost() -> void:
	if Input.is_action_just_pressed("boost") and boost_timer.is_stopped():
		apply_boost()
		boost_timer.start()

func try_dash() -> void:
	var hud: HUD = Global.get_hud()
	
	if hud and hud.oxygen <= dash_oxygen_reduce_amount:
		return
	
	if Input.is_action_just_pressed("dash") and dash_timer.is_stopped():
		state_machine.activate_state_by_name.call_deferred("DashState")

func try_bounce() -> void:
	if not get_slide_collision_count():
		return
	
	var collision: KinematicCollision2D = get_last_slide_collision()
	var collision_point: Vector2 = collision.get_position()
	
	var bounce_dir: Vector2 = Vector2(
			signf(get_wall_normal().x) if is_on_wall() else 0.0,
			-1.0 if is_on_floor() else 1.0 if is_on_ceiling() else 0.0
	)
	
	if bounce_dir.y:
		velocity.y = bounce_dir.y * bounce_of_wall_force.y
	elif bounce_dir.x:
		velocity.x = bounce_dir.x * bounce_of_wall_force.x
	
	if SandBounceParticles.get_particles_amount(self) < max_sand_particles_amount:
		SandBounceParticles.from_scene(collision_point, bounce_dir)
	
	bounce_timer.start()

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
