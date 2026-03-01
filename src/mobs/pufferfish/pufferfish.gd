class_name Pufferfish
extends Area2D

@export var deflated_throw_force: float
@export var inflate_pause_player_time: float

@export_group("Camera")
@export var inflate_camera_shake_strength: float
@export var inflate_camera_shake_fade: float

@onready var shape: Node2D = $Shape as Node2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var inflated_timer: Timer = $InflatedTimer as Timer

func throw_player(player: Player) -> void:
	var dir_to_player: Vector2 = global_position.direction_to(player.global_position)
	
	player.velocity = deflated_throw_force * dir_to_player.normalized()

func update_flip_h() -> void:
	if anim_player.current_animation in ["inflate", "deflate"]:
		return
	
	var player: Player = Global.Game.get_player()
	
	if player:
		shape.scale.x = absf(shape.scale.x) * 1.0 if player.global_position.x <= global_position.x else -1.0
