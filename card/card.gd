extends PhysicsBody3D
class_name Card


@export var resource: GameResource
@export var is_draggable: bool = true

@onready var stack: Stack = %Stack
@onready var model: MeshInstance3D = %Model
@onready var shape: CollisionShape3D = %Shape
