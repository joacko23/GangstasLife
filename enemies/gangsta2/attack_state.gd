extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var speed: int = 50

var player: CharacterBody2D

func enter() -> void:
	# Detectar al jugador en el grupo
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		player = players[0] as CharacterBody2D

	if animated_sprite_2d:
		animated_sprite_2d.play("attack")

func on_physics_process(delta: float) -> void:
	if player:
		var direction = (player.global_position - character_body_2d.global_position).normalized()
		character_body_2d.velocity = direction * speed
		character_body_2d.move_and_slide()

func exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()
	character_body_2d.velocity = Vector2.ZERO
	player = null
