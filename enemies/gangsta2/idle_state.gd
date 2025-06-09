extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

func enter() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")

func on_physics_process(delta: float) -> void:
	if character_body_2d.is_on_floor():
		character_body_2d.velocity = Vector2.ZERO  # Sin movimiento

func exit() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.stop()


