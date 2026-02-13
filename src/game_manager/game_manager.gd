class_name GameManager
extends Node

signal level_changed(level: Node)

var current_level: Node
var _current_level_scene: PackedScene

@onready var level_viewport: LevelViewport = %LevelViewport as LevelViewport
@onready var hud: HUD = %HUD as HUD
@onready var pause_menu: PauseMenu = %PauseMenu as PauseMenu


func setup(level_scene: PackedScene) -> void:
	current_level = await level_viewport.add_level(level_scene, self)
	level_changed.emit(current_level)
	
	hud.oxygen_reduce_timer.start()

func reset() -> void:
	level_viewport.reset()
	hud.reset()

func switch_level_to_packed(level_scene: PackedScene, play_transitions: bool = true) -> void:
	current_level = null
	_current_level_scene = level_scene
	
	get_tree().paused = true
	pause_menu.enabled = false
	
	if play_transitions:
		Global.play_end_transition()
		await Global.end_transition_finished
	
	reset()
	
	if not level_scene or not level_scene.can_instantiate():
		return
	
	await setup(level_scene)
	
	if play_transitions:
		Global.play_start_transition()
		await Global.start_transition_finished
	
	get_tree().paused = false
	pause_menu.enabled = true

func switch_level_to_file(level_path: String, play_transitions: bool = true) -> void:
	var level_scene: PackedScene = load(level_path) as PackedScene
	
	switch_level_to_packed(level_scene, play_transitions)

func reload_current_level() -> void:
	switch_level_to_packed(_current_level_scene)
