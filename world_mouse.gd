extends Node3D
class_name WorldMouse

@export var camera: Camera3D

@export var world_ray_cast: RayCast3D
@export var card_ray_cast: RayCast3D

const RAY_LENGTH: int = 1000
var _hovered: Card


func hovered_or_null() -> Card:
	return _hovered


func is_hovering() -> bool:
	return _hovered != null


func _card_ray_cast() -> Card:
	if !card_ray_cast.is_colliding(): return null
	var card = card_ray_cast.get_collider() as Card
	return card if card.is_draggable else null


func _physics_process(_delta: float) -> void:
	_hovered = _card_ray_cast()
	if world_ray_cast.is_colliding():
		position = world_ray_cast.get_collision_point()


func add_exceptions(cards: Array[Card]) -> void:
	if card_ray_cast == null: return
	for c in cards:
		card_ray_cast.add_exception(c)
	
func clear_exceptions() -> void:
	if card_ray_cast == null: return
	card_ray_cast.clear_exceptions()
