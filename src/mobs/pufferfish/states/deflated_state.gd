class_name PufferfishDeflatedState
extends PufferfishState

func _state_machine_ready() -> void:
	super._state_machine_ready()
	pufferfish.body_entered.connect(_on_body_entered)

func _enter(_previous_state: State) -> void:
	pufferfish.anim_player.play("deflated_idle")

func _physics_update(_delta: float) -> void:
	pufferfish.update_flip_h()

func _on_body_entered(body: Node2D) -> void:
	if not is_active():
		return
	
	var player: Player = body as Player
	
	if not player:
		return
	
	apply_throw(player)

func apply_throw(player: Player) -> void:
	inflate()
	await player.disable_for(pufferfish.inflate_pause_player_time)
	
	Global.Camera.apply_shake(pufferfish.inflate_camera_shake_strength, pufferfish.inflate_camera_shake_fade)
	pufferfish.throw_player(player)

func inflate() -> void:
	pufferfish.anim_player.play("inflate")
	
	await pufferfish.anim_player.animation_finished
	
	switch_to("InflatedState")
