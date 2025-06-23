extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@onready var timer = $Timer


func enter():
	# Reproduce la animación de daño
	animated_sprite_2d.play("hurt")

	# Detiene el movimiento
	character_body_2d.velocity.x = 0

	# Inicia un pequeño tiempo antes de volver al estado idle o walk
	timer.start()

func _on_timer_timeout():
	transition.emit("walk")  

func exit():
	# Opcional: detener animación
	animated_sprite_2d.stop()

