extends Node2D

# Card scene to instance
@export var card_scene: PackedScene
@export var deal_duration: float = 0.5
@export var deal_delay: float = 0.2

var deck: Array = []
var discard_pile: Array = []

# Positions
@export var deck_position: Vector2 = Vector2(50, 90)
@export var hand_start_position: Vector2 = Vector2(100, 120)
@export var card_spacing: float = 40

func _ready():
	initialize_deck()

func initialize_deck():
	# Create a deck of cards (example: 52 cards)
	deck.clear()
	var suits = ["H", "D", "C", "S"]
	var values = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
	
	for suit in suits:
		for value in values:
			deck.append({"suit": suit, "value": value})
	
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func deal_cards(num_cards: int, target_positions: Array = []):
	for i in range(num_cards):
		if deck.is_empty():
			print("No more cards in deck!")
			break
		
		await get_tree().create_timer(deal_delay * i).timeout
		
		var card_data = deck.pop_front()
		var card = card_scene.instantiate()
		add_child(card)
		
		# Set initial position at deck
		card.position = deck_position
		card.set_card_data(card_data)
		
		# Calculate target position
		var target_pos: Vector2
		if target_positions.size() > i:
			target_pos = target_positions[i]
		else:
			target_pos = hand_start_position + Vector2(i * card_spacing, 0)
		
		# Animate card to hand
		animate_card_deal(card, target_pos)

func animate_card_deal(card: Node2D, target_position: Vector2):
	var tween = create_tween()
	tween.tween_property(card, "position", target_position, deal_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#tween.parallel().tween_property(card, "rotation", randf_range(-0.1, 0.1), deal_duration)
