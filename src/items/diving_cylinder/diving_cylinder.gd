class_name DivingCylinder
extends Area2D

@export var oxygen_increase_amount: float
@export var oxygen_pause_time: float

var is_anim_playing: bool = false

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

func _ready() -> void:
	animation_player.play("pingpong")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var hud: HUD = Global.get_hud()
		
		if not hud:
			return
		
		hud.oxygen += oxygen_increase_amount
		
		hud.oxygen_reduce_timer.stop()
		await get_tree().create_timer(oxygen_pause_time, false, true).timeout
		hud.oxygen_reduce_timer.start()
		
		queue_free()
