class_name Main
extends Node

signal level_changed

var current_level: Node

@onready var sub_viewport: SubViewport = %SubViewport as SubViewport
@onready var hud: HUD = %HUD as HUD
@onready var pause_menu: PauseMenu = %PauseMenu as PauseMenu
@onready var start_menu: StartMenu = %StartMenu as StartMenu

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen") and not OS.get_name() == "Web":
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func switch_level_to_packed(level: PackedScene, play_end_anim: bool = false, enable_start_menu: bool = true) -> void:
	if not level:
		return
	
	if play_end_anim:
		start_menu.animation_player.play("end")
		await start_menu.animation_player.animation_finished
		await get_tree().create_timer(start_menu.time_after_end_anim).timeout
	
	start_menu.started = not enable_start_menu
	
	for child: Node in sub_viewport.get_children():
		child.queue_free()
	
	var level_inst: Node = level.instantiate()
	
	hud.reset()
	hud.oxygen_reduce_timer.stop()
	pause_menu.enabled = false
	sub_viewport.add_child.call_deferred(level_inst)
	level_inst.set_deferred("owner", self)
	set_deferred("current_level", level_inst)
	_on_level_changed.call_deferred()

func switch_level_to_file(level_path: String, play_end_anim: bool = false, enable_start_menu: bool = true) -> void:
	var level: PackedScene = load(level_path) as PackedScene
	
	switch_level_to_packed(level, play_end_anim, enable_start_menu)

func reload_current_level(play_end_anim: bool = true, enable_start_menu: bool = false) -> void:
	get_tree().paused = true
	
	switch_level_to_file(current_level.scene_file_path, play_end_anim, enable_start_menu)

func _on_level_changed() -> void:
	level_changed.emit()
	get_tree().paused = true
	
	start_menu.animation_player.play("start")
	await start_menu.animation_player.animation_finished
	
	if start_menu.started:
		get_tree().paused = false
