extends Node2D
class_name SandBounceParticles


## the scene of this class.
const PARTICLES_SCENE_UID: String = "uid://c6hw6y40w6jeq"
const GROUP_NAME: StringName = &"sand_particles"

## preset sizes for the sand particles emission box.
enum BoxSize
{
	VERTICAL = 8,
	HORIZONTAL = 16,
}

## dispawn timer :P
var dispawn_timer: Timer = Timer.new()


var emission_direction: Vector2


func _ready() -> void:
	setup_dispawn_timer()
	
	%SandParticles.process_material.direction = Vector3(emission_direction.x, emission_direction.y, 0.0)
	%SandParticles.emitting = true
	

## [param accesor] is a node in the scene tree to let the function acess it.
static func from_scene(pos: Vector2, direction: Vector2) -> void:
	var instance: SandBounceParticles = load(PARTICLES_SCENE_UID).instantiate()
	
	instance.global_position = pos
	instance.emission_direction = direction
	
	Global.Levels.get_current().add_child(instance)

static func get_particles_amount(accesor: Node) -> int:
	return accesor.get_tree().get_nodes_in_group(GROUP_NAME).size()

func setup_dispawn_timer() -> void:
	dispawn_timer.wait_time = %SandParticles.lifetime
	dispawn_timer.timeout.connect(self.queue_free)
	add_child(dispawn_timer)
	dispawn_timer.start()


func set_emission_direction(value: Vector2) -> void:
	%SandParticles.process_material.direction = value
