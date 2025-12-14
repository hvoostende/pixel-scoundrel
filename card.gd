extends Node2D

var card_data: Dictionary = {}

@onready var sprite = $Sprite2D  # or your card visual node
@onready var label = $Label      # for displaying value

func set_card_data(data: Dictionary):
	card_data = data
	update_visuals()

func update_visuals():
	# Update the card's appearance based on data
	if label:
		label.text = card_data.value + "\n" + card_data.suit
	
	# Load appropriate texture
	# sprite.texture = load("res://cards/" + card_data.suit + "_" + card_data.value + ".png")

func _ready():
	# Make cards clickable
	var area = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(48, 64)  # adjust to your card size
	collision.shape = shape
	area.add_child(collision)
	add_child(area)
	area.input_event.connect(_on_card_clicked)

func _on_card_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Card clicked: ", card_data)
