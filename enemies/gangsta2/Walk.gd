extends NodeState

@export var character_body_2d: CharacterBody2D
@export var patrol_points: Node
@export var speed: int = 150
@export var animated_sprite_2d: AnimatedSprite2D

var point_positions = []
var current_point_index = 0
var direction = Vector2.LEFT

func enter() -> void:
	if patrol_points:
		point_positions = patrol_points.get_children().map(func(p): return p.global_position)
		if point_positions.size() > 0:
			_set_next_target()

	if animated_sprite_2d:
		animated_sprite_2d.play("walk")

func on_physics_process(delta: float) -> void:
	if point_positions.size() == 0:
		return

	var target = point_positions[current_point_index]
	if character_body_2d.global_position.distance_to(target) > 5:
		# Aplicar movimiento hacia el objetivo
		var velocity = (target - character_body_2d.global_position).normalized() * speed
		character_body_2d.velocity.x = velocity.x
	else:
		# Cambiar al siguiente punto
		current_point_index = (current_point_index + 1) % point_positions.size()
		if get_parent() and get_parent().has_method("transition_to"):
			get_parent().transition_to("idle")
		return

func exit() -> void:
	character_body_2d.velocity = Vector2.ZERO
	if animated_sprite_2d:
		animated_sprite_2d.stop()

func _set_next_target() -> void:
	var target = point_positions[current_point_index]
	direction = (target - character_body_2d.global_position).normalized()
	if animated_sprite_2d:
		animated_sprite_2d.flip_h = direction.x < 0


