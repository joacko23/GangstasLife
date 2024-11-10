extends NodeState

@export var character_body_2d : CharacterBody2D
@export var patrol_points : Node
@export var speed : int = 1500
@export var animated_sprite_2d : AnimatedSprite2D

var point_positions = []
var current_point_index = 0
var direction = Vector2.LEFT

func enter() -> void:
	if patrol_points:
		# Cargar posiciones de los puntos de patrulla
		point_positions = patrol_points.get_children().map(func(p): return p.global_position)
		if point_positions.size() > 0:
			# Configurar el primer objetivo
			_set_next_target()

	if animated_sprite_2d:
		animated_sprite_2d.play("walk")  # Iniciar animación al entrar

func on_physics_process(delta: float) -> void:
	if point_positions.size() == 0:
		return  # No hay puntos de patrulla

	var target = point_positions[current_point_index]
	if character_body_2d.global_position.distance_to(target) > 5:
		# Mover hacia el objetivo
		character_body_2d.velocity.x = direction.x * speed * delta
		character_body_2d.move_and_slide()
	else:
		# Llegó al punto, avanzar al siguiente
		current_point_index = (current_point_index + 1) % point_positions.size()
		if get_parent() and get_parent().has_method("transition_to"):
			get_parent().transition_to("idle")  # Cambiar a idle al llegar al punto
		return

func exit() -> void:
	# Detener la velocidad y la animación al salir
	character_body_2d.velocity = Vector2.ZERO
	if animated_sprite_2d:
		animated_sprite_2d.stop()

func _set_next_target() -> void:
	# Actualizar dirección hacia el próximo objetivo
	var target = point_positions[current_point_index]
	direction = (target - character_body_2d.global_position).normalized()
	if animated_sprite_2d:
		animated_sprite_2d.flip_h = direction.x < 0


