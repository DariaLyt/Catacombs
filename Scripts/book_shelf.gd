extends StaticBody2D

@export var bookshelf_id: String = ""
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var player_in_range = false
var is_looted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var main_node = get_tree().root.get_child(0)
	if bookshelf_id in main_node.looted_containers:
		set_as_looted()


func _input(event):
	if event.is_action_pressed("ui_select") and player_in_range and not is_looted:
		loot_bookshelf()

func loot_bookshelf():
	is_looted = true
	var main_node = get_tree().root.get_child(0)
	
	# Randomize item count (0 to 2)
	var item_count = randi() % 3 
	print("Looted barrel! Found ", item_count, " items.")
	
	for i in range(item_count):
		var random_item = main_node.books_list.pick_random()
		main_node.player_items.append(random_item)
	
	# Mark as looted globally
	main_node.looted_containers.append(bookshelf_id)
	set_as_looted()

func set_as_looted():
	is_looted = true
	animated_sprite_2d.modulate = Color(0.5, 0.5, 0.5)

func _on_loot_range_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		print("player entered")

func _on_loot_range_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		print("player exited")
