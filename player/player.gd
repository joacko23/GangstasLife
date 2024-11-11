extends CharacterBody2D

var bullet = preload("res://player/bullet.tscn")
var player_death_effect = preload("res://player/player_death_effect/player_death_effect.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle: Marker2D = $Muzzle

@export var walk_speed = 500.0
@export var run_speed = 1000.0
@export var max_horizontal_speed_walk = 150
@export var max_horizontal_speed_run = 300
@export var slow_down_speed = 1700

@export var jump_velocity = -400.0
@export var jump_horizontal_speed = 1000.0
@export var max_jump_horizontal_speed = 300



enum State {Idle, Walk, Run, Jump, Shoot, Hurt}
var current_state : State
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var muzzle_position 


func _ready():
	current_state = State.Idle
	muzzle_position = muzzle.position

func _physics_process(delta : float):
	# Actualiza las físicas primero
	player_falling(delta)
	
	# Manejo de la lógica de movimiento y estados
	player_run_or_walk(delta)
	player_jump(delta)
	
	player_muzzle_position()
	player_sooting(delta)
	
	move_and_slide()
	
	# Gestiona las animaciones según el estado
	player_animations()
	
	#print("State: ", State.keys()[current_state])

func player_falling(delta : float):
	# Aplica la gravedad si el personaje no está en el suelo
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		# Si está en el suelo y estaba en el estado de salto, vuelve a Idle, Walk o Run
		if current_state == State.Jump:
			if velocity.x != 0:
				current_state = State.Run if Input.is_action_pressed("run") else State.Walk
			else:
				current_state = State.Idle

func player_run_or_walk(delta : float):
	# Si el personaje está disparando y no se ha terminado la animación, no se mueve
	if current_state == State.Shoot and animated_sprite_2d.animation == "shoot":
		return
	
	# Si el personaje está en "Hurt", no se mueve
	if current_state == State.Hurt:
		return
	
	var direction = input_movement()
	
	# Control del movimiento horizontal solo si está en el suelo
	if is_on_floor():
		if direction != 0:
			# Si se presiona la tecla para correr
			if Input.is_action_pressed("run"):
				velocity.x += direction * run_speed * delta
				velocity.x = clamp(velocity.x, -max_horizontal_speed_run, max_horizontal_speed_run)
				current_state = State.Run
			else:
				velocity.x += direction * walk_speed * delta
				velocity.x = clamp(velocity.x, -max_horizontal_speed_walk, max_horizontal_speed_walk)
				current_state = State.Walk
				
			animated_sprite_2d.flip_h = direction < 0  # Gira el sprite
		else:
			velocity.x = move_toward(velocity.x, 0, slow_down_speed * delta)  
			if current_state in [State.Walk, State.Run]:
				current_state = State.Idle

func player_jump(delta : float):
	# Inicia el salto si está en el suelo
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		current_state = State.Jump
	
	# Control del movimiento horizontal en el aire (opcional)
	if not is_on_floor() and current_state == State.Jump:
		var direction = input_movement()
		velocity.x += direction * jump_horizontal_speed * delta
		velocity.x = clamp(velocity.x, -max_jump_horizontal_speed, max_jump_horizontal_speed)
		
		# Girar el personaje en el aire según la dirección del movimiento
		if direction != 0:
			animated_sprite_2d.flip_h = direction < 0

func player_sooting(delta : float):
	if Input.is_action_just_pressed("shoot"):
		# Instanciar la bala
		var bullet_instance = bullet.instantiate() as Node2D
		
		# Determina la dirección de la bala según hacia dónde esté mirando el personaje
		if animated_sprite_2d.flip_h:
			bullet_instance.direction = -1  # Izquierda
		else:
			bullet_instance.direction = 1  # Derecha

		# Posición inicial de la bala
		bullet_instance.global_position = muzzle.global_position
		
		# Agregar la bala a la escena
		get_parent().add_child(bullet_instance)
		
		# Cambiar al estado de disparo y detener el movimiento
		current_state = State.Shoot
		velocity.x = 0  # Detener al personaje
		# Asegurar que la animación de disparo se reproduzca
		animated_sprite_2d.play("shoot")

func _on_shoot_animation_finished():
	# Cuando termina la animación de disparo, vuelve a Idle, Walk o Run
	if is_on_floor():
		if abs(velocity.x) > 0:
			current_state = State.Run if Input.is_action_pressed("run") else State.Walk
		else:
			current_state = State.Idle
	else:
		current_state = State.Jump


func player_muzzle_position():
	var direction = input_movement()
	
	if direction > 0:
		muzzle.position.x = muzzle_position.x
	elif direction < 0:
		muzzle.position.x = - muzzle_position.x

func player_animations():
	if current_state == State.Hurt:
		animated_sprite_2d.play("hurt")
		return  # Prioridad sobre las demás animaciones
	
	if current_state == State.Idle:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk:
		animated_sprite_2d.play("walk")
	elif current_state == State.Run:
		animated_sprite_2d.play("run")
	elif current_state == State.Jump:
		animated_sprite_2d.play("jump")
	elif current_state == State.Shoot:
		animated_sprite_2d.play("shoot")

func input_movement():
	var direction : float = Input.get_axis("move_left", "move_right")
	return direction


func _on_animated_sprite_2d_animation_finished():
	# Cuando termina la animación de disparo, sale del estado Shoot si estaba disparando
	if animated_sprite_2d.animation == "shoot" and current_state == State.Shoot:
		# Cambiar al estado adecuado después de disparar
		if is_on_floor():
			if abs(velocity.x) > 0:
				current_state = State.Run if Input.is_action_pressed("run") else State.Walk
			else:
				current_state = State.Idle
		else:
			current_state = State.Jump
	
	# Cuando termina la animación de "hurt", vuelve al estado adecuado
	elif animated_sprite_2d.animation == "hurt" and current_state == State.Hurt:
		# Cambiar al estado adecuado después de recibir daño
		if is_on_floor():
			if abs(velocity.x) > 0:
				current_state = State.Run if Input.is_action_pressed("run") else State.Walk
			else:
				current_state = State.Idle
		else:
			current_state = State.Jump

func player_death():
	var player_death_effect_instance = player_death_effect.instantiate() as Node2D
	player_death_effect_instance.global_position = global_position
	get_parent().add_child(player_death_effect_instance)
	get_tree().reload_current_scene()
	queue_free()

func _on_hurt_box_body_entered(body: Node2D):
	if body.is_in_group("Enemy"):
		if body.has_method("get_damage_amount"):  # Verificar si tiene el método
			var damage = body.get_damage_amount()
			print("Enemy entered, Damage Amount: ", damage)
			current_state = State.Hurt
			HealthManager.decrease_health(damage)
		else:
			print("Enemy does not have get_damage_amount method!")
	
	if HealthManager.current_health == 0:
		player_death()




func _on_floor_body_entered(body):
	if body.is_in_group("Player"):
		player_death()
