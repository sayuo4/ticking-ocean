extends Node

var MainScene: PackedScene = preload("res://src/main/main.tscn")

func setup_main(default_level_path: String) -> void:
	get_tree().change_scene_to_packed.call_deferred(MainScene)
	
	await get_tree().scene_changed
	
	switch_level_to_file(default_level_path)

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

func get_current_level() -> Node:
	var main: Main = get_main()
	
	if main:
		return main.current_level
	
	return null

func reload_current_level(play_end_anim: bool = true, enable_start_menu: bool = false) -> void:
	var main: Main = get_main()
	
	if main:
		main.reload_current_level(play_end_anim, enable_start_menu)
