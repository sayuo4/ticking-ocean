class_name Main
extends Node

signal level_changed

var current_level: Node

@onready var sub_viewport: SubViewport = %SubViewport as SubViewport
@onready var hud: HUD = %HUD as HUD

func switch_level_to_packed(level: PackedScene, play_end_anim: bool = false) -> void:
	if not level:
		return
	
	if play_end_anim:
		hud.animation_player.play("end")
		await hud.animation_player.animation_finished
		await get_tree().create_timer(hud.time_after_end_anim).timeout
	
	for child: Node in sub_viewport.get_children():
		child.queue_free()
	
	var level_inst: Node = level.instantiate()
	
	
	hud.reset()
	hud.oxygen_reduce_timer.stop()
	sub_viewport.add_child.call_deferred(level_inst)
	level_inst.set_deferred("owner", self)
	set_deferred("current_level", level_inst)
	_on_level_changed.call_deferred()

func switch_level_to_file(level_path: String, play_end_anim: bool = false) -> void:
	var level: PackedScene = load(level_path) as PackedScene
	
	switch_level_to_packed(level, play_end_anim)

func reload_current_level(play_end_anim: bool = true) -> void:
	get_tree().paused = true
	
	switch_level_to_file(current_level.scene_file_path, play_end_anim)

func _on_level_changed() -> void:
	level_changed.emit()
	get_tree().paused = true
	
	hud.animation_player.play("start")
	await hud.animation_player.animation_finished
	
	get_tree().paused = false
