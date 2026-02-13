class_name DivingCylinder
extends Area2D

@export var oxygen_increase_amount: float
@export var oxygen_pause_time: float
@export var fade_time: float

var fade: float: set = set_fade

@onready var sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var point_light: PointLight2D = $PointLight2D as PointLight2D

func _ready() -> void:
	$Sprite2D.material = $Sprite2D.material.duplicate()
	animation_player.play("pingpong")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var hud: HUD = Global.UI.get_hud()
		
		if not hud:
			return
		
		hud.oxygen += oxygen_increase_amount
		hud.pause_oxygen_for(oxygen_pause_time)
		
		collision_shape.set_deferred("disabled", true)
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(self, "fade", 1.0, fade_time)
		tween.tween_property(point_light, "energy", 0.0, fade_time)
		
		await tween.finished
		
		queue_free()

func set_fade(value: float) -> void:
	fade = value
	
	var sprite_material: ShaderMaterial = sprite.material as ShaderMaterial
	
	if sprite_material and sprite_material.get_shader_parameter("fade") != null:
		sprite_material.set_shader_parameter("fade", value)
