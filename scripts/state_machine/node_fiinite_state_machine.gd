class_name NodeFiniteStateMachine
extends Node

@export var initial_node_state: NodeState
var node_state: Dictionary = {}
var current_node_state: NodeState = null
var current_node_state_name: String = ""

func _ready() -> void:
	# Registrar estados
	for child in get_children():
		if child is NodeState:
			node_state[child.name.to_lower()] = child

	# Configurar el estado inicial
	if initial_node_state:
		transition_to(initial_node_state.name.to_lower())
	else:
		if node_state.size() > 0:
			transition_to(node_state.keys()[0])
		else:
			print("No hay estados disponibles en la máquina de estados.")

func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta)

func transition_to(node_state_name: String) -> void:
	# Si ya estamos en este estado, no hacemos nada
	if current_node_state and current_node_state.name.to_lower() == node_state_name.to_lower():
		return

	# Buscar el nuevo estado
	var new_node_state = node_state.get(node_state_name.to_lower(), null)
	if !new_node_state:
		print("Estado no encontrado: ", node_state_name)
		return

	# Cambiar estado
	if current_node_state:
		current_node_state.exit()

	current_node_state = new_node_state
	current_node_state_name = node_state_name.to_lower()
	current_node_state.enter()

	print("Estado actual: ", current_node_state_name)





