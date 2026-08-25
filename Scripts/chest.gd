extends StaticBody2D

@export var chest_id: String = ""
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_in_range = false
var is_looted = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_apply_looted_state")

func _apply_looted_state() -> void:
	var main_node = get_tree().get_first_node_in_group("game_main")
	if main_node == null:
		return
	if chest_id in main_node.looted_containers:
		set_as_looted()


func _input(event):
	if event.is_action_pressed("ui_select") and player_in_range and not is_looted:
		loot_chest()

func loot_chest():
	is_looted = true
	var main_node = get_tree().get_first_node_in_group("game_main")
	
	# Randomize item count (0 to 2)
	var item_count = randi() % 3 
	print("Looted barrel! Found ", item_count, " items.")
	
	for i in range(item_count):
		# Pick a random item from your game's master list
		var random_item = main_node.inventory_items_list.pick_random()
		#var flag = random_item.get("flag")
		#if flag == 0:
		main_node.player_inventory.append(random_item)
		#else:
			#main_node.player_items.append(random_item)
	
	# Mark as looted globally
	main_node.looted_containers.append(chest_id)
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
