extends CharacterBody2D

@export var health_amount: int = 3
@export var damage_amount: int = 1
@export var speed: int = 150
@export var node_finite_state_machine: NodeFiniteStateMachine

@onready var animated_sprite = $AnimatedSprite2D


func _ready():
	if node_finite_state_machine:
		node_finite_state_machine.transition_to("idle")  # Inicia en idle

func _physics_process(delta: float):
	if node_finite_state_machine and node_finite_state_machine.current_node_state:
		node_finite_state_machine.current_node_state.on_physics_process(delta)

	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		take_damage(node.get_damage_amount())

func take_damage(amount: int):
	health_amount -= amount
	print("Enemy health: ", health_amount)
	if health_amount <= 0:
		die()

func die():
	animated_sprite.play("dead")
	animated_sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	if animated_sprite.animation == "dead":
		queue_free()

func get_damage_amount() -> int:
	return damage_amount




