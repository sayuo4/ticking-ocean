class_name Spikes
extends Area2D

@onready var safe_area: Area2D = $SafeArea as Area2D

func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player and not safe_area.overlaps_body(player):
		player.kill() 
