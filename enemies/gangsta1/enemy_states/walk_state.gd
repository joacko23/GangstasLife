extends NodeState

@export var character_body_2d : CharacterBody2D
@export var animated_sprite_2d : AnimatedSprite2D
@export var timer : Timer

var direction := Vector2.LEFT

func enter():
	animated_sprite_2d.play("walk")

func on_physics_process(delta):
	var enemy = character_body_2d
	var target_point = enemy.point_positions[enemy.current_point_position]
	
	if abs(enemy.position.x - target_point.x) > 0.5:
		enemy.velocity.x = direction.x * enemy.speed * delta
	else:
		enemy.current_point_position += 1
		if enemy.current_point_position >= enemy.number_of_points:
			enemy.current_point_position = 0

		var next_point = enemy.point_positions[enemy.current_point_position]
		direction = Vector2.RIGHT if next_point.x > enemy.position.x else Vector2.LEFT
		animated_sprite_2d.flip_h = -direction.x > 0

		enemy.velocity.x = 0 
		enemy.can_walk = false
		timer.start()

		transition.emit("idle")

