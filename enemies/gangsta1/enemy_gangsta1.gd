extends CharacterBody2D

var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

@export var patrol_points : Node
@export var speed : int = 1500
@export var wait_time : int = 3
@export var health_amount : int = 3
@export var demage_amount : int = 1

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var timer = $Timer
@onready var state_machine = $StateMachine

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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

func _physics_process(delta : float):
	enemy_gravity(delta)
	move_and_slide()


func enemy_gravity(delta : float):
	velocity.y += gravity * delta


func get_damage_amount() -> int:
	return demage_amount


func _on_timer_timeout():
	can_walk = true


func _on_hurtbox_area_entered(area : Area2D):
	print("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= node.damage_amount
		print("Health amount: ", health_amount)
		
		if health_amount <= 0:
			enemy_die()
		else:
			state_machine.transition_to("hurt")

func enemy_die():
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


func _on_shoot_range_body_entered(body):
	if body.is_in_group("Player"):
		$StateMachine.transition_to("shoot")
