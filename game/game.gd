extends Node

var cards: CardList
var resources: Array[GameResource] = []
var elapsed_time_in_biome: float
var biome: Node = null:
	set(_biome):
		biome = _biome
		elapsed_time_in_biome=0

func clear():
	elapsed_time_in_biome = 0

func spawn() -> Card:
	#assert(spawner!=null, "spawner is null")
	assert(cards!=null, "cards is null")
	#var card = spawner.spawn()
	#cards.add_child(card)
	#return card
	return null

func _ready() -> void:
	# loads all game resoucres
	var path := "res://data/resource/"
	for n in DirAccess.get_files_at(path):
		if !n.ends_with(".tres"): continue
		var p := path+n
		var r := load(p) as GameResource
		resources.append(r)

func _process(delta: float) -> void:
	elapsed_time_in_biome += delta
