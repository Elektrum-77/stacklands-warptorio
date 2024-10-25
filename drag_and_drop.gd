extends Node
class_name DragAndDrop

@export var world_mouse: WorldMouse

var _offset: Vector3 = Vector3.ZERO
var _dragged: Card

func _drag():
	var hovered = world_mouse.hovered_or_null()
	if hovered == null: return
	if hovered.stack.has_parent(): hovered.stack.split()
	
	_offset = hovered.position - world_mouse.position
	_offset.y = 0
	_dragged = hovered
	world_mouse.add_exceptions(hovered.stack.collect())


func _drop():
	if (_dragged==null): return
	
	var hovered = world_mouse.hovered_or_null()
	if hovered != null: hovered.stack.add_card(_dragged)
	
	_offset = Vector3.ZERO
	_dragged = null
	world_mouse.clear_exceptions()


func _input(event: InputEvent) -> void:
	if !event is InputEventMouseButton: return 
	if event.button_index != MOUSE_BUTTON_LEFT: return
	match event.pressed:
		true: _drag()
		false: _drop()


func _physics_process(_delta: float) -> void:
	if _dragged==null: return
	_dragged.position = world_mouse.position + _offset
