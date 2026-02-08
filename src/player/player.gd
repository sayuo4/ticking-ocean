class_name Player
extends CharacterBody2D

signal player_bounced(dir: Vector2)

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

@onready var shape: Node2D = $Shape as Node2D
@onready var state_machine: StateMachine = $StateMachine as StateMachine
@onready var sprite: Sprite2D = %Sprite2D as Sprite2D

@onready var boost_timer: Timer = %BoostTimer as Timer
@onready var dash_timer: Timer = %DashTimer as Timer
@onready var bounce_timer: Timer = %BounceTimer as Timer

func _ready() -> void:
	var hud: HUD = Global.get_hud()
	
	if hud:
		await get_tree().create_timer(start_oxygen_time).timeout
		hud.oxygen_reduce_timer.start()
		hud.oxygen_finished.connect(_on_oxygen_finished)
	
	var pause_menu: PauseMenu = Global.get_pause_menu()
	
	if pause_menu:
		pause_menu.enabled = true

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

func try_bounce(delta: float) -> void:
	var speed: Vector2 = get_position_delta() / delta
	
	if not speed or not get_slide_collision_count():
		return
	
	var dir: Vector2 = speed.sign()
	var collision_position: Vector2 = get_last_slide_collision().get_position()
	var collision_dir: Vector2 = Vector2.ZERO
	
	if is_on_floor() or is_on_ceiling():
		velocity.y = -dir.y * bounce_of_wall_force.y
		collision_dir = Vector2.DOWN * dir.y
		
		if SandBounceParticles.get_particles_amount(self) < max_sand_particles_amount:
			SandBounceParticles.from_scene(collision_position, -dir)
		
	elif is_on_wall():
		velocity.x = -dir.x * bounce_of_wall_force.x
		collision_dir = Vector2.RIGHT * dir.x
		if SandBounceParticles.get_particles_amount(self) < max_sand_particles_amount:
			SandBounceParticles.from_scene(collision_position, -dir)
	
	player_bounced.emit(collision_dir)
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
