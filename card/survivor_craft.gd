extends Timer
class_name SurvivorCrafting

@export var crafts: CraftList
@onready var crafts_lookup: Dictionary = crafts.look_up_table()
@onready var card: Card = $".."

var current_craft: Craft = null


func cancel() -> void:
	if (!is_stopped()): stop()
	current_craft = null

func _on_updated(_other: Card) -> void:
	var cards = card.stack.collect()
	var others = cards.filter(func (_c:Card): return _c!=card)
	var str_craft = Craft.from_cards(others)
	var c := crafts_lookup.get(str_craft, null) as Craft
	if (c==null):
		cancel()
		return
	current_craft = c
	start(c.time)

func _on_extracted() -> void:
	cancel()

func _on_timeout() -> void:
	var result := current_craft.result.spawn()
	result.position = Vector3.ZERO
	var resources = card.stack.extract()
	current_craft=null
	# TODO add VFX on craft
	resources.queue_free()
