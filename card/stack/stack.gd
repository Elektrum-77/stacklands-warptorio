extends Node
class_name Stack

const stack_offest: Vector3 = Vector3(0,0.01, 1)

@onready var card: Card = $".."
@export var added_card_filter: AddedCardFilter

signal added(child: Card)
signal splitted(child: Card)
signal extracted()

class ExtractionResult:
	var old_stack: Card
	var new_stack: Card
	func _init(old: Card, new: Card) -> void:
		assert(new!=null)
		old_stack = old
		new_stack = new

func has_parent() -> bool:
	return parent_card_or_null()!=null

func has_child() -> bool:
	return child_card_or_null()!=null

# GETTERS
func child_card_or_null() -> Card:
	if (get_child_count()==0): return
	return get_child(0)

func parent_card_or_null() -> Card:
	var parent := card.get_parent() as Stack
	if (not parent is Stack): return null
	return parent.card

func top_card() -> Card:
	var parent := parent_card_or_null()
	if (parent == null): return card
	return parent.stack.top_card()

func bot_card() -> Card:
	var child := child_card_or_null()
	if (child == null): return card
	return child.stack.bot_card()


# EMITS
func _emit_added(other: Card):
	assert(child_card_or_null()==null, "can only emit from bottom")
	__emit_added(other)

func __emit_added(other: Card):
	added.emit(other)
	var parent := parent_card_or_null()
	if (parent == null):
		Game.cards.updated.emit(card)
		return
	parent.stack.__emit_added(other)


func _emit_splitted(other: Card):
	assert(child_card_or_null()==null, "can only emit from bottom")
	__emit_splitted(other)

func __emit_splitted(other: Card):
	splitted.emit(other)
	var parent := parent_card_or_null()
	if (parent == null):
		Game.cards.updated.emit(card)
		return
	parent.stack.__emit_splitted(other)


func _emit_extracted():
	assert(parent_card_or_null()==null, "this card still has a parent, something is wrong")
	extracted.emit()
	Game.cards.added.emit(card)

# STACK MANIPULATION
# recursion is any->top->bot

func collect() -> Array[Card]:
	var collected: Array[Card] = []
	top_card().stack.__collect_rec(collected)
	return collected

func __collect_rec(cards: Array[Card]):
	cards.append(card)
	var child := child_card_or_null()
	if (child == null): return cards
	child.stack.__collect_rec(cards)


### Returns true if the card was add false otherwise
func add_card(other: Card) -> bool:
	return top_card().stack.__add_card(other)

func __add_card(other: Card) -> bool:
	assert(other!=card, "cannot add myself to my stack")
	var child := child_card_or_null()
	if (child != null): return child.stack.__add_card(other)
	if !added_card_filter.filter(other): return false
	other.reparent(self)
	other.stack.bot_card().stack._emit_added(other)
	return true


### Extract n (default n=1) card from the current stack to form a new stack and returns the top of the old stack.
func extract(distance: int = 1) -> Card:
	assert(distance>=1, "cannot extract less than 1 card")
	var parent := parent_card_or_null()
	var child = __traverse_down(distance)
	if (parent!=null):
		card.reparent(Game.cards)
		child.reparent(parent.stack)
		child.stack.bot_card().stack._emit_splitted(card)
		_emit_extracted()
		return parent.stack.top_card()
	child.stack.split() # returns self.card
	return child

func __traverse_down(distance: int) -> Card:
	assert(distance>=0, "cannot traverse negative distance")
	if (distance==0): return card
	var child := child_card_or_null()
	assert(child!=null, "stack is too small to traverse")
	return child.stack.__traverse_down(distance-1)


### Split the current stack at this card and returns the top of the old stack
func split() -> Card:
	var parent := parent_card_or_null()
	assert(parent!=null, "nothing to split")
	card.reparent(Game.cards)
	parent.stack._emit_splitted(card)
	_emit_extracted()
	return parent.stack.top_card()


# PHYSICS
func _follow_parent():
	var parent := parent_card_or_null()
	if (parent==null): return
	card.position = parent.position + stack_offest

func _physics_process(_delta: float) -> void:
	_follow_parent()
