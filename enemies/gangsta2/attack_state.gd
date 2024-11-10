extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var speed : int

var player : CharacterBody2D
var max_speed : int

func enter() -> void:
	# Buscar al jugador en el grupo "Player"
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0] as CharacterBody2D
	max_speed = speed + 20  # Ajustar velocidad máxima

func on_physics_process(delta: float) -> void:
	if !player:  # Evitar errores si no hay jugador
		return

	var direction: int

	if character_body_2d.global_position.x > player.global_position.x:
		animated_sprite_2d.flip_h = true
		direction = -1
	elif character_body_2d.global_position.x < player.global_position.x:
		animated_sprite_2d.flip_h = false
		direction = 1

	if animated_sprite_2d:
		animated_sprite_2d.play("attack")

	character_body_2d.velocity.x += direction * speed * delta
	character_body_2d.velocity.x = clamp(character_body_2d.velocity.x, -max_speed, max_speed)
	character_body_2d.move_and_slide()

func exit() -> void:
	# Limpiar lógica y detener animación
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	character_body_2d.velocity = Vector2.ZERO
	player = null  # Limpiar referencia al jugador
