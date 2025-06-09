extends Node

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	if !character_body_2d.is_on_floor():
		character_body_2d.velocity.y += GRAVITY * delta
	
	character_body_2d.move_and_slide()
	
