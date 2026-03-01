class_name PufferfishInflatedState
extends PufferfishState

func _state_machine_ready() -> void:
	super._state_machine_ready()
	pufferfish.body_entered.connect(_on_body_entered)

func _enter(_previous_state: State) -> void:
	pufferfish.anim_player.play("inflated_idle")
	pufferfish.inflated_timer.start()
	
	await pufferfish.inflated_timer.timeout
	
	deflate()

func _physics_update(_delta: float) -> void:
	pufferfish.update_flip_h()

func _on_body_entered(body: Node2D) -> void:
	if not is_active():
		return
	
	var player: Player = body as Player
	
	if not player:
		return
	
	player.kill()

func deflate() -> void:
	pufferfish.anim_player.play("deflate")
	
	await pufferfish.anim_player.animation_finished
	
	switch_to("DeflatedState")
