class_name NodeFiniteStateMachine
extends Node

#Asignar el estado inicial 
@export var initial_node_state: NodeState
#Estados disponibles, clave:nombre en minuscula, valor nodo del tipo NodeState
var node_state: Dictionary = {}
#Estado actual activo
var current_node_state: NodeState = null
#Nombre en texto del estado actual
var current_node_state_name: String = ""

func _ready() -> void:
	# Busca y registra un estado hijo con texto
	for child in get_children():
		if child is NodeState:
			node_state[child.name.to_lower()] = child
			#Conecta la señal transition con la función transition_to para permitir transiciones automáticas entre estados.
			child.transition.connect(transition_to)

	# Configurar el estado inicial
	if initial_node_state:
		transition_to(initial_node_state.name.to_lower())
	#Si no hay estado inicial toma el primero del diccionario
	else:
		if node_state.size() > 0:
			transition_to(node_state.keys()[0])
		else:
			print("No hay estados disponibles en la máquina de estados.")

#Llama al método on_process() del estado activo
func _process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state.on_physics_process(delta)

#Cambia el estado actual a otro estado con el nombre que se le pasa.
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





