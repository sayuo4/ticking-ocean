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
	
	hud.reset()
	hud.oxygen_reduce_timer.stop()
	sub_viewport.add_child.call_deferred(level_inst)
	level_inst.set_deferred("owner", self)
	set_deferred("current_level", level_inst)
	_on_level_changed.call_deferred()

func switch_level_to_file(level_path: String) -> void:
	var level: PackedScene = load(level_path) as PackedScene
	
	switch_level_to_packed(level)

func reload_current_level() -> void:
	get_tree().paused = true
	
	hud.animation_player.play("end")
	await hud.animation_player.animation_finished
	
	switch_level_to_file(current_level.scene_file_path)

func _on_level_changed() -> void:
	level_changed.emit()
	get_tree().paused = true
	
	hud.animation_player.play("start")
	await hud.animation_player.animation_finished
	
	get_tree().paused = false
