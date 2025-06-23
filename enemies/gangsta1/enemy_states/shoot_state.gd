extends NodeState

@export var character_body_2d: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var muzzle: Marker2D
@export var shoot_cooldown_timer: Timer

var bullet_scene := preload("res://player/bullet.tscn")
var player: Node2D = null
var detection_area: Area2D = null

func enter():
	print("Entrando al estado SHOOT")
	player = get_tree().get_first_node_in_group("Player")
	detection_area = character_body_2d.get_node("ShootRange")

	if player == null or detection_area == null:
		transition.emit("idle")
		return

	# Detener movimiento horizontal
	character_body_2d.velocity.x = 0

	# Determinar dirección hacia el jugador
	_update_direction()

	# Comenzar a disparar si puede
	if shoot_cooldown_timer.is_stopped():
		animated_sprite_2d.play("shoot")
		_disparar_bala()
		shoot_cooldown_timer.start()

func on_physics_process(_delta: float) -> void:
	if player == null or detection_area == null:
		transition.emit("idle")
		return

	# Si el jugador salió del área de disparo
	if not detection_area.get_overlapping_bodies().has(player):
		print("Jugador salió del rango")
		transition.emit("idle")
		return

	# Actualizar dirección mientras el jugador está en rango
	_update_direction()


func _update_direction():
	if player.global_position.x < character_body_2d.global_position.x:
		animated_sprite_2d.flip_h = true
		muzzle.position.x = -abs(muzzle.position.x)
	else:
		animated_sprite_2d.flip_h = false
		muzzle.position.x = abs(muzzle.position.x)

func _disparar_bala():
	print("Disparando bala")
	var bullet_instance = bullet_scene.instantiate()

	# Establecer dirección según flip
	bullet_instance.direction = -1 if animated_sprite_2d.flip_h else 1

	# Posicionar la bala en el muzzle
	bullet_instance.global_position = muzzle.global_position

	# Agregar la bala a la escena
	character_body_2d.get_parent().add_child(bullet_instance)

func exit():
	print("Saliendo del estado SHOOT")
	animated_sprite_2d.stop()



func _on_timer_timeout():
	# Solo volver a disparar si sigue en el estado shoot
	if player and detection_area.get_overlapping_bodies().has(player):
		animated_sprite_2d.play("shoot")
		_disparar_bala()
		shoot_cooldown_timer.start()
	else:
		transition.emit("idle")
