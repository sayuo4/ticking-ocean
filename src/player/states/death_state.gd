class_name PlayerDeathState
extends PlayerState

func _enter(_previous_state: State) -> void:
	Global.reload_current_level()
