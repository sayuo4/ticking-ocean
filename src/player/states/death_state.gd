class_name PlayerDeathState
extends PlayerState

var fade: float: set = set_fade

func _state_machine_ready() -> void:
	super._state_machine_ready()
	fade = 0.0

func _enter(_previous_state: State) -> void:
	Global.Camera.apply_shake(player.death_camera_shake_strength, player.death_camera_shake_fade)
	var pause_menu: PauseMenu = Global.UI.get_pause_menu()
	
	if pause_menu:
		pause_menu.enabled = false
	
	var hud: HUD = Global.UI.get_hud()
	
	if hud:
		hud.oxygen_reduce_timer.stop()
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "fade", 1.0, player.fade_time)
	
	await tween.finished
	await get_tree().create_timer(player.after_fade_time, false).timeout
	
	Global.Levels.reload_current()

func set_fade(value: float) -> void:
	fade = value
	
	var sprite_material: ShaderMaterial = player.sprite.material as ShaderMaterial
	
	if sprite_material and sprite_material.get_shader_parameter("fade") != null:
		sprite_material.set_shader_parameter("fade", value)
