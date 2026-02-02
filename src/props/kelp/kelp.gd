extends Node2D
class_name Kelp

## how many "kelp tile" this kelp has.
@export var tall: int = 3
## if both min and max tall were not zero, the tall property will be set in between min_tall and max_tall
@export var max_tall: int = 0
## if both min and max tall were not zero, the tall property will be set in between min_tall and max_tall
@export var min_tall: int = 0
@export_group("Textures")
## the texure of the bottom of the kelp.
@export var root_texture: Texture2D
## the texture of the stem (the repeating part)
@export var stem_texture: Texture2D
## the texture of the top of the kelp.
@export var top_texture: Texture2D



func _ready() -> void:
	_generate_stems()

func _generate_stems() -> void:
	
	if min_tall && max_tall:
		tall = randi_range(min_tall, max_tall)
	
	printt(min_tall, max_tall)
	print(tall)
	
	# root
	%RootSprite.texture = root_texture
	%RootSprite.position.y = 0.0
	
	
	# stems
	var current_pos: float = -((root_texture.get_height() / 2.0) + stem_texture.get_height() / 2.0)
	for i: int in tall:
		var stem_sprite := Sprite2D.new()
		stem_sprite.texture = stem_texture
		stem_sprite.position.y = current_pos
		current_pos -= float(stem_texture.get_height()) if i != tall -1 else 12.0 # hard coded yeah.
		add_child(stem_sprite)
	
	
	# top
	%TopSprite.texture = top_texture
	%TopSprite.position.y = current_pos
