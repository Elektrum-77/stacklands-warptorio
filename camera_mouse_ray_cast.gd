extends Camera3D
class_name CameraMouseRayCast

const RAY_LENGTH := 1000
var ray_casts: Array[RayCast3D] = []

func _ready() -> void:
	for child in get_children():
		ray_casts.append(child as RayCast3D)


func _physics_process(_delta: float) -> void:
	var screen_position := get_viewport().get_mouse_position()
	var normal := project_local_ray_normal(screen_position)
	var from := normal # offset for debug visibility
	var to := normal * RAY_LENGTH
	for ray in ray_casts:
		ray.position = from
		ray.target_position = to
