extends Node
@export var node_finite_state_machine : NodeFiniteStateMachine


func change_state_based_on_body(body: Node2D, target_state: String) -> void:
	if body.is_in_group("Player") and node_finite_state_machine:
		node_finite_state_machine.transition_to(target_state)


func _on_attack_area_2d_body_entered(body : Node2D)-> void:
	change_state_based_on_body(body, "attack")



func _ready() -> void:
	if node_finite_state_machine:
		node_finite_state_machine.transition_to("walk")  # Estado inicial.
