extends Resource
class_name CraftList

@export var items: Array[Craft]

func look_up_table() -> Dictionary:
	var table = {}
	for c in items:
		table[c.look_up()] = c
	return table
