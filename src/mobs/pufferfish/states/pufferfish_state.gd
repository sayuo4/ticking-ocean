class_name PufferfishState
extends State

var pufferfish: Pufferfish

func _state_machine_ready() -> void:
	if target_node is not Pufferfish:
		push_error("Pufferfish state '%s' target node isn't a Pufferfish." % get_path())
		return
	
	pufferfish = target_node as Pufferfish
