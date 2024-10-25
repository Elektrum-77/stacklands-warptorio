extends MeshInstance3D


@export var world_mouse: WorldMouse
@export var hovering_color: Color
var default_color: Color
var material: BaseMaterial3D

func _ready() -> void:
	material = get_active_material(0)
	default_color = material.albedo_color

func _process(_delta: float) -> void:
	material.albedo_color = hovering_color if world_mouse.is_hovering() else default_color
