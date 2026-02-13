class_name LevelViewport
extends SubViewport

func add_level(level_scene: PackedScene, level_owner: Node) -> Node:
	var level_inst: Node = level_scene.instantiate()
	
	add_child.call_deferred(level_inst)
	level_inst.set_deferred("owner", level_owner)
	
	await level_inst.ready
	
	return level_inst

func reset() -> void:
	for child: Node in get_children(true):
		child.queue_free()
