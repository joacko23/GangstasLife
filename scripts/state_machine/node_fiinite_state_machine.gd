class_name NodeFiniteStateMachine
extends Node

@export var initial_node_state : NodeState

var node_state : Dictionary = {}
var current_node_state : NodeState
var current_node_state_name : String

func _ready() -> void:
	# Registrar estados
	for child in get_children():
		if child is NodeState:
			node_state[child.name.to_lower()] = child

	# Configurar el estado inicial
	if initial_node_state:
		transition_to(initial_node_state.name.to_lower())
	else:
		transition_to("walk")  # Por defecto, comenzar con "walk"

func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta)

func transition_to(node_state_name: String) -> void:
	if current_node_state and current_node_state.name.to_lower() == node_state_name.to_lower():
		return  # Evitar transicionar al mismo estado

	var new_node_state = node_state.get(node_state_name.to_lower())
	
	if !new_node_state:
		print("State does not exist: ", node_state_name)
		return  # Estado no encontrado

	if current_node_state:
		current_node_state.exit()  # Salir del estado actual

	current_node_state = new_node_state
	current_node_state_name = node_state_name.to_lower()
	
	current_node_state.enter()  # Entrar al nuevo estado
	print("Transitioned to state: ", current_node_state_name)



