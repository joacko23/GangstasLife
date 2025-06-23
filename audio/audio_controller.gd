extends Node2D

@export var mute: bool = false

func _ready():
	if not mute:
		play_music()


func play_music():
	if not mute:
		$Music.play()


func play_shoot():
	if not mute:
		$Shoot.play()


func play_walk():
	if not mute and not $Walk.playing:
		$Walk.play()

func stop_walk():
	if $Walk.playing:
		$Walk.stop()

func play_jump():
	if not mute:
		$Jump.play()


func play_hurt():
	if not mute:
		$Hurt.play()


func play_death():
	if not mute:
		stop_walk()
		$Death.play()


func play_pause():
	if not mute:
		$Pause.play()


func play_money():
	if not mute:
		$Money.stop()
		$Money.play()


func play_pickup():
	if not mute:
		$Pickup.stop()
		$Pickup.play()

func play_end_level():
	if not mute:
		$Music.stop()
		$EndLevel.play()


func play_select():
	if not mute:
		$Select.play()
