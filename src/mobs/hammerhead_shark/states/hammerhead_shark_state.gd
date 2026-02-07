class_name HammerheadSharkState
extends State

var shark: HammerheadShark

func _state_machine_ready() -> void:
	if target_node is not HammerheadShark:
		push_error("HammerheadShark state '%s' target node isn't a HammerheadShark." % get_path())
		return
	
	shark = target_node as HammerheadShark
