extends Node2D

@export var pickup_amount : int = 1
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $HealthPickupBox/CollisionShape2D


func _on_health_pickup_box_body_entered(body):
	if body.is_in_group("Player"):
		HealthManager.increase_health(pickup_amount)
		AudioController.play_pickup()
		animated_sprite_2d.visible = false
		collision_shape_2d.call_deferred("set", "disabled", true)
		


func _on_pickup_sound_finished():
	queue_free()
