extends CharacterBody2D

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

@export var patrol_points : Node
@export var speed : int = 1500
@export var wait_time : int = 3
@export var health_amount : int = 3
@export var demage_amount : int = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State { Idle, Walk }
var current_state : State
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_positions : Array[Vector2]
var current_point : Vector2
var current_point_position : int
var can_walk : bool 




func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_positions.append(point.global_position)
		current_point = point_positions[current_point_position]
	else:
		print("No patrol points")
	
	timer.wait_time = wait_time
	current_state = State.Idle

func _physics_process(delta : float):
	enemy_gravity(delta)
	enemy_idle(delta)
	enemy_walk(delta)
	
	move_and_slide()
	
	enemy_animations()

func enemy_gravity(delta : float):
	velocity.y += gravity * delta

func enemy_idle(delta : float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, speed)
		current_state = State.Idle

func enemy_walk(delta : float):
	if !can_walk:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * speed * delta
		current_state = State.Walk
	else:
		current_point_position += 1
	
		if current_point_position >= number_of_points:
			current_point_position = 0
		
		current_point = point_positions[current_point_position]
	
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else :
			direction = Vector2.LEFT
			
		animated_sprite_2d.flip_h = - direction.x > 0
		can_walk = false
		timer.start()
		
		
func get_damage_amount() -> int:
	return demage_amount
	
	
	
func enemy_animations():
	# Cambia la animación según el estado actual
	if current_state == State.Idle && !can_walk:
		animated_sprite_2d.play("idle")
	elif current_state == State.Walk && can_walk:
		animated_sprite_2d.play("walk")


func _on_timer_timeout():
	can_walk = true


func _on_hurtbox_area_entered(area : Area2D):
	print("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		
		if health_amount <= 0:
			 # Instanciar el efecto de muerte
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D

			 # Usar la posición global del enemigo justo antes de eliminarlo
			enemy_death_effect_instance.global_position = global_position
			
			# Ajustar la posición en el eje Y para que coincida con el AnimatedSprite2D
			enemy_death_effect_instance.position.y = animated_sprite_2d.global_position.y
			
			# Hacer que el efecto de muerte se vea en la misma dirección que el enemigo
			if animated_sprite_2d.flip_h:
				enemy_death_effect_instance.scale.x = -abs(enemy_death_effect_instance.scale.x)  # Girar el efecto a la izquierda
			else:
				enemy_death_effect_instance.scale.x = abs(enemy_death_effect_instance.scale.x)   # Girar el efecto a la derecha

			# Añadir el efecto de muerte al mismo padre del enemigo
			get_parent().add_child(enemy_death_effect_instance)
			
			# Eliminar al enemigo
			queue_free()
