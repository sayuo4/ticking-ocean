class_name Spikes
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	var player: Player = body as Player
	
	if player:
		print("Player touched spikes!")
		# TODO: Damage the player.
