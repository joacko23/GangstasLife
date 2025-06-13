extends Node

static var total_award_amount : int 

signal on_collectible_award_received

func give_pickup_award(collectible_award : int):
	total_award_amount += collectible_award
	
	on_collectible_award_received.emit(total_award_amount)

func reset_awards():
	total_award_amount = 0
	on_collectible_award_received.emit(total_award_amount)
