extends Node
class_name CardList

signal added(card: Card)
signal removed(card: Card)
signal updated(card: Card)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.cards = self
