extends Timer
class_name AI

@onready var card: Card = $".."
@export var target: Vector3
@export var distance: float
@export var speed: float


func _on_timeout() -> void:
	var direction := card.position.direction_to(target)
	direction.y = 0
	var offset = direction * distance
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", card.position + offset, speed).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(start)
