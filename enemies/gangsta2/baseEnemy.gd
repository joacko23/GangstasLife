extends CharacterBody2D

@export var health_amount : int = 3
@export var damage_amount : int = 1
@export var speed : int = 1500
@export var death_effect : PackedScene
@export var node_finite_state_machine : NodeFiniteStateMachine

@onready var animated_sprite = $AnimatedSprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	if node_finite_state_machine:
		node_finite_state_machine.transition_to("idle")  # Iniciar en walk

func _physics_process(delta: float):
	if node_finite_state_machine and node_finite_state_machine.current_node_state:
		node_finite_state_machine.current_node_state.on_physics_process(delta)
	
	move_and_slide()


func take_damage(amount : int):
	health_amount -= amount
	if health_amount <= 0:
		die()

func die():
	if death_effect:
		var effect = death_effect.instantiate() as Node2D
		effect.global_position = global_position
		get_parent().add_child(effect)
	queue_free()

func apply_gravity(delta : float):
	velocity.y += gravity * delta

func get_damage_amount() -> int:
	return damage_amount

