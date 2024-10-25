extends Spawner
class_name SpawnerResource

@export var resource: GameResource

const CARD = preload("res://card/card.tscn")


func spawn() -> Card:
	var card = CARD.instantiate()
	card.resource = resource
	Game.cards.add_child(card)
	Game.cards.added.emit(card)
	return card
