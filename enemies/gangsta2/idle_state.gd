extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var idle_duration : float = 1.0
@onready var timer : Timer = Timer.new()

func enter() -> void:
	if animated_sprite_2d:
		animated_sprite_2d.play("idle")  # Iniciar animación

	# Configuración del Timer
	timer.wait_time = idle_duration
	timer.one_shot = true

	# Agregar el Timer al árbol ANTES de conectar la señal
	add_child(timer)

	# Conectar la señal "timeout" correctamente
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	# Iniciar el Timer
	timer.start()

func _on_timer_timeout() -> void:
	if get_parent() and get_parent().has_method("transition_to"):
		get_parent().transition_to("walk")  # Cambiar al estado "walk"


func exit() -> void:
	# Detener y liberar el Timer
	if timer and timer.is_inside_tree():
		timer.stop()
		timer.queue_free()

	# Detener la animación
	if animated_sprite_2d:
		animated_sprite_2d.stop()
