extends Resource
class_name Craft

@export var consumed: Array[GameResource]
@export var result: Spawner
@export_range(0, 120, 0.5, "or_greater") var time: float

func look_up()->String:
	return from_resources(consumed)

static func from_resources(items: Array[GameResource]) -> String:
	var resources: Dictionary = {}
	for r in items:
		resources[r] = resources.get(r, 0) + 1
	return _dict_hash(resources)

static func from_cards(cards: Array[Card]) -> String:
	var resources: Dictionary = {}
	for c in cards:
		var r = c.resource
		resources[r] = resources.get(r, 0) + 1
	return _dict_hash(resources)

static func _dict_hash(resources: Dictionary) -> String:
	var h = ""
	for r in Game.resources:
		var count = resources.get(r, 0)
		if (count==0): continue
		h += "%s:%d," % [r.to_string(), count]
	if (null in resources): h += "null:%d" % resources[null]
	return h
