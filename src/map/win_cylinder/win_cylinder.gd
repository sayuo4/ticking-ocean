class_name WinCylinder
extends StaticBody2D

@export var switch_to_scene: PackedScene
@export var is_level: bool = true
@export var time_after_enter: float

@onready var player_shape: Node2D = $PlayerShape as Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer

func _on_detect_player_area_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		player_shape.scale.y = player.shape.scale.x
		player.hide()
		player.process_mode = Node.PROCESS_MODE_DISABLED
		
		var hud: HUD = Global.UI.get_hud()
		
		if hud:
			hud.oxygen_reduce_timer.stop()
		
		animation_player.play("player_enter")
		await animation_player.animation_finished
		await get_tree().create_timer(time_after_enter, false).timeout
		
		if not switch_to_scene:
			Global.Levels.reload_current()
			return
		
		if is_level:
			Global.Levels.switch_to_packed(switch_to_scene)
		else:
			Global.Scenes.switch_to_packed(switch_to_scene)
