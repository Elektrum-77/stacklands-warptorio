extends Node
class_name Move

@onready var card: Card = $".." 
@export var speed: float

@export_group("link")
@export var area: Area3D
@export var model: MeshInstance3D

var target: Vector3
var is_following: bool


func _follow_target(delta: float):
	if (!is_following): return
	if (target==null): return
	var difference = target - card.position
	if (difference.length_squared() <= (speed/60)**2):
		card.position+=difference
		return
	var direction := difference.normalized()
	var offset := direction * speed * delta
	card.position += offset

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_follow_target(delta)
