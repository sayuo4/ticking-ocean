extends Node

signal start_transition_finished
signal end_transition_finished

@export var after_end_transition_time: float

var MainScene: PackedScene = preload("res://src/main/main.tscn")

@onready var transition_animation_player: AnimationPlayer = %TransitionAnimationPlayer as AnimationPlayer

func setup_main(default_level_path: String) -> void:
	get_tree().change_scene_to_packed.call_deferred(MainScene)
	
	await get_tree().scene_changed
	
	switch_level_to_file(default_level_path)

func play_start_transition() -> void:
	transition_animation_player.play("start_transition")
	await transition_animation_player.animation_finished
	start_transition_finished.emit()

func play_end_transition() -> void:
	transition_animation_player.play("end_transition")
	await transition_animation_player.animation_finished
	await get_tree().create_timer(after_end_transition_time, true).timeout
	end_transition_finished.emit()

func is_playing_transition() -> bool:
	return transition_animation_player.is_playing()

func get_main() -> Main:
	var main: Main = get_tree().current_scene as Main
	
	return main

func get_hud() -> HUD:
	var hud: HUD = get_tree().get_first_node_in_group("hud") as HUD
	
	return hud

func get_player() -> Player:
	var player: Player = get_tree().get_first_node_in_group("player") as Player
	
	return player

func get_pause_menu() -> PauseMenu:
	var pause_menu: PauseMenu = get_tree().get_first_node_in_group("pause_menu") as PauseMenu
	
	return pause_menu

func get_player_camera() -> PlayerCamera:
	var camera: PlayerCamera = get_tree().get_first_node_in_group("player_camera") as PlayerCamera
	
	return camera

func apply_camera_shake(strength: float, fade: float) -> void:
	var camera: PlayerCamera = get_player_camera()
	
	if camera:
		camera.apply_shake(strength, fade)

func apply_zoom(value: Vector2, fade: float) -> void:
	var camera: PlayerCamera = get_player_camera()
	
	if camera:
		camera.apply_zoom(value, fade)

func enable_pause_menu() -> void:
	var pause_menu: PauseMenu = get_pause_menu()
	
	if pause_menu:
		pause_menu.enabled = true

func start_oxygen_timer(on_oxygen_finished: Callable) -> void:
	var hud: HUD = get_hud()
	
	if hud:
		hud.oxygen_reduce_timer.start()
		hud.oxygen_finished.connect(on_oxygen_finished)

func get_start_menu() -> StartMenu:
	var start_menu: StartMenu = get_tree().get_first_node_in_group("start_menu") as StartMenu
	
	return start_menu

func switch_level_to_packed(level: PackedScene, play_end_anim: bool = false, enable_start_menu: bool = true) -> void:
	var main: Main = get_main()
	
	if main:
		main.switch_level_to_packed(level, play_end_anim, enable_start_menu)

func switch_level_to_file(level_path: String, play_end_anim: bool = false, enable_start_menu: bool = true) -> void:
	var main: Main = get_main()
	
	if main:
		main.switch_level_to_file(level_path, play_end_anim, enable_start_menu)

func switch_scene_to_packed(scene: PackedScene, play_end_anim: bool = true, play_start_anim: bool = true) -> void:
	if play_end_anim:
		play_end_transition()
		await end_transition_finished
	
	get_tree().paused = true
	
	get_tree().change_scene_to_packed(scene)
	await get_tree().scene_changed
	
	if play_start_anim:
		play_start_transition()
		await start_transition_finished
	
	get_tree().paused = false

func get_current_level() -> Node:
	var main: Main = get_main()
	
	if main:
		return main.current_level
	
	return null

func reload_current_level(play_end_anim: bool = true, enable_start_menu: bool = false) -> void:
	var main: Main = get_main()
	
	if main:
		main.reload_current_level(play_end_anim, enable_start_menu)
