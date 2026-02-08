class_name WinCylinder
extends StaticBody2D

@export var next_level: PackedScene
@export var time_after_enter: float

@onready var player_shape: Node2D = $PlayerShape as Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

func _on_detect_player_area_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player_shape.scale.y = player.shape.scale.x
		player.hide()
		player.process_mode = Node.PROCESS_MODE_DISABLED
		
		animation_player.play("player_enter")
		await animation_player.animation_finished
		await get_tree().create_timer(time_after_enter, false).timeout
		
		Global.switch_level_to_packed(next_level, true, false)
