class_name Main
extends Node

signal level_changed

var current_level: Node

@onready var sub_viewport: SubViewport = %SubViewport as SubViewport
@onready var hud: HUD = %HUD as HUD

func switch_level_to_packed(level: PackedScene) -> void:
	if not level:
		return
	
	for child: Node in sub_viewport.get_children():
		child.queue_free()
	
	var level_inst: Node = level.instantiate()
	
	hud.oxygen_reduce_timer.stop()
	hud.reset()
	sub_viewport.add_child.call_deferred(level_inst)
	level_inst.set_deferred("owner", self)
	set_deferred("current_level", level_inst)
	level_changed.emit.call_deferred()

func switch_level_to_file(level_path: String) -> void:
	var level: PackedScene = load(level_path) as PackedScene
	
	switch_level_to_packed(level)

func reload_current_level() -> void:
	switch_level_to_file(current_level.scene_file_path)
