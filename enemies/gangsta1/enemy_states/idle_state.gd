extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

func on_process(delta : float):
	pass

func on_physics_process(delta :float):
	#Transicion a walk
	if character_body_2d.can_walk:
		transition.emit("walk")
	
	#Transicion a shoot
	var player = get_tree().get_first_node_in_group("Player")
	if player and character_body_2d.get_node("ShootRange").get_overlapping_bodies().has(player):
		transition.emit("shoot")

func enter():
	character_body_2d.velocity.x = 0
	animated_sprite_2d.play("idle")


func exit():
	animated_sprite_2d.stop()
