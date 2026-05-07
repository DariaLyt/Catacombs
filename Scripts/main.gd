extends Node2D

@onready var fade: ColorRect = $HUD/Fade

@onready var inventory_menu: CanvasLayer = $InventoryMenu
@onready var combat_menu = $HUD/Combat_menu
@onready var pause_menu: CanvasLayer = $PauseMenu

@onready var camera_2d: Camera2D = $Camera2D

#@onready var health_bar: ProgressBar = $HUD/HealthBar

#level setup
var level: int = 1
var current_level_node: Node = null
var travel_direction: String = "next"

#trap
var player_on_trap: bool = false
var trap_cooldown_timer: float = 0.0
var TRAP_DAMAGE_DELAY: float = 1.0

#enemy
var active_enemy: Node2D = null
var defeated_enemies = []

#pause flag
var paused = false

#hp
var max_health:int = 100
var current_health:int = 100

#player
var player_inventory = []
var player_equipment = {"weapon": null, "shield": null, "head": null, "body": null, "accessory": null}
var player_items = []

var looted_containers = [] 
var all_items_list = [
	{"item_name": "small potion", "type": "healing", "amount": 10, "texture": preload("res://Assets/collectibles/small_potions.png"), "description": "small healing potion", "flag": 1},
	{"item_name": "medium potion", "type": "healing", "amount": 25, "texture": preload("res://Assets/collectibles/medium_potions.png"), "description": "medium healing potion", "flag": 1},
	{"item_name": "big potion", "type": "healing", "amount": 50, "texture": preload("res://Assets/collectibles/big_potions.png"), "description": "big healing potion", "flag": 1},
	{"item_name": "damage potion", "type": "attack", "amount": 20, "texture": preload("res://Assets/collectibles/items/damage_boost.png"), "description": "bottle of snake blood for damage boost", "flag": 1},
	{"item_name": "defense potion", "type": "defense", "amount": 15, "texture": preload("res://Assets/collectibles/items/defense_boost.png"), "description": "tears of a golem", "flag": 1},
]

var inventory_items_list = [
	{"item_name": "Wooden sword", "type": "weapon", "attack_mod": 5, "health_mod": 0, "defense_mod": 0, "agility_mod": -1, "luck_mod": 0, "texture": preload("res://Assets/collectibles/wooden_sword.png"), "description": "Wooden sword", "flag": 0, "one-handed": true},
	{"item_name": "Leather helmet", "type": "head", "attack_mod": 0, "health_mod": 0, "defense_mod": 10, "agility_mod": 0, "luck_mod": 0, "texture": preload("res://Assets/collectibles/leather_helmet.png"),"description": "Basic protection for your head.", "flag": 0},
	{"item_name": "Wooden shield", "type": "shield", "attack_mod": 0, "health_mod": 0, "defense_mod": 30, "agility_mod": 0,"luck_mod": 0, "texture": preload("res://Assets/collectibles/shield.png"),"description": "wooden shield", "flag": 0},
	{"item_name": "magic wand", "type": "weapon", "attack_mod": 10, "health_mod": 0, "defense_mod": -2, "agility_mod": -2, "luck_mod": 0, "texture": preload("res://Assets/collectibles/weapon_014.png"), "description": "A wand of a fallen mage", "flag": 0, "one-handed": true},
	{"item_name": "iron sword", "type": "weapon", "attack_mod": 10, "health_mod": 0, "defense_mod": 0, "agility_mod": -1, "luck_mod": 0, "texture": preload("res://Assets/collectibles/weapon_000.png"), "description": "iron sword", "flag": 0, "one-handed": true},
	{"item_name": "Wooden bow", "type": "weapon", "attack_mod": 5, "health_mod": 0, "defense_mod": -1, "agility_mod": -1, "luck_mod": 0, "texture": preload("res://Assets/collectibles/weapon_003.png"), "description": "Wooden bow", "flag": 0, "one-handed": false},
	{"item_name": "iron spear", "type": "weapon", "attack_mod": 10, "health_mod": 0, "defense_mod": -2, "agility_mod": -3, "luck_mod": 0, "texture": preload("res://Assets/collectibles/weapon_024.png"), "description": "iron spear", "flag": 0, "one-handed": false},
	{"item_name": "Crimson axe", "type": "weapon", "attack_mod": 25, "health_mod": 0, "defense_mod": -5, "agility_mod": -8, "luck_mod": 2, "texture": preload("res://Assets/collectibles/weapon_034.png"), "description": "axe on an ancient godssa", "flag": 0},
	{"item_name": "iron helmet", "type": "head", "attack_mod": 0, "health_mod": 0, "defense_mod": 15, "agility_mod": 0, "luck_mod": 0, "texture": preload("res://Assets/collectibles/armor/armor_000.png"),"description": "Advanced protection for your head.", "flag": 0},
	{"item_name": "magic hood", "type": "head", "attack_mod": 0, "health_mod": 0, "defense_mod": 10, "agility_mod": 5, "luck_mod": 5, "texture": preload("res://Assets/collectibles/armor/armor_005.png"),"description": "magic hood", "flag": 0},
	{"item_name": "iron chestplate", "type": "body", "attack_mod": 0, "health_mod": 0, "defense_mod": 15, "agility_mod": -1, "luck_mod": 0, "texture": preload("res://Assets/collectibles/armor/armor_008.png"),"description": "Basic protection for your body.", "flag": 0},
	{"item_name": "magic cape", "type": "body", "attack_mod": 0, "health_mod": 0, "defense_mod": 5, "agility_mod": 2, "luck_mod": 1, "texture": preload("res://Assets/collectibles/armor/armor_013.png"),"description": "magical protection for your body.", "flag": 0},
	{"item_name": "bug necklace", "type": "accessory", "attack_mod": 0, "health_mod": 5, "defense_mod": 0, "agility_mod": 0, "luck_mod": 5, "texture": preload("res://Assets/collectibles/armor/armor_041.png"),"description": "weird bug in stone.", "flag": 0},
	{"item_name": "old scarf", "type": "accessory", "attack_mod": 0, "health_mod": 0, "defense_mod": 3, "agility_mod": 0, "luck_mod": 2, "texture": preload("res://Assets/collectibles/armor/armor_053.png"),"description": "who left it here?.", "flag": 0},
	{"item_name": "golden ring", "type": "accessory", "attack_mod": 2, "health_mod": 2, "defense_mod": 2, "agility_mod": 2, "luck_mod": 2, "texture": preload("res://Assets/collectibles/armor/armor_062.png"),"description": "i can feel its power", "flag": 0},
]

var books_list = [
	{"itemsname": "Dusty book", "type": "book", "unlocks_skill": "Dash", "description": "There's a wind coming out of the book", "texture": preload("res://Assets/collectibles/items/book1.png"), "flag": 1},
]

var master_skills = {
	"Talk": {"description": "Attempt to reason with the enemy.", "icon": "res://Assets/ui/skill.png"},
	"Run": {"description": "Try to flee from battle.", "icon": "res://Assets/ui/skill.png"},
	"FireBall": {"description": "Launch a ball of fire (Requires Fire Book).", "icon": "res://Assets/ui/skill.png"},
	"Heal": {"description": "Restore a small amount of HP (Requires Holy Book).", "icon": "res://Assets/ui/skill.png"},
	"Escape plan": {"description": "Increase your chances", "icon": "res://Assets/ui/skill.png"},
	"Steal": {"description": "take a look into enemy pockets", "icon": "res://Assets/ui/skill.png"},
	"Dash": {"description": "Increase your walking speed", "icon": "res://Assets/ui/skill.png"},
	"Suicide": {"description": "There are worse fates than death. Sometimes it's good to go on your own terms...", "icon": "res://Assets/ui/skill.png"},
}

var learned_skills = ["Talk", "Run", "Escape plan"]

var last_save_point: Vector2 = Vector2.ZERO
var saved_inventory: Array = []
var saved_items: Array = []
var saved_equipment: Dictionary = {}
var saved_skills: Array = []
var saved_health: int = 100
var saved_lvl: int = 1
var is_respawning: bool = false

#initial setup
func _ready() -> void:
	fade.modulate.a = 1.0
	current_level_node = get_node("LevelRoot")
	_load_level(level)
	pause_menu.hide()
	inventory_menu.hide()
	#_fill_player_inventory()

func _process(delta: float) -> void:
	if trap_cooldown_timer > 0:
		trap_cooldown_timer -= delta
	if player_on_trap and trap_cooldown_timer <= 0:
		var trap = current_level_node.get_node_or_null("Floor_trap")
		if trap:
			var sprite = trap.get_node("AnimatedSprite2D")
			if sprite.frame >= 6:
				update_health(-5) 
				trap_cooldown_timer = TRAP_DAMAGE_DELAY

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if inventory_menu.visible:
			toggle_inventory()
		else:
			toggle_pause()
	if event.is_action_pressed("inventory"):
		if not pause_menu.visible:
			toggle_inventory()

func _assign_camera_to_player(player: Node2D) -> void:
	var remote_transform = player.get_node_or_null("CameraFollower")
	if !remote_transform:
		remote_transform = RemoteTransform2D.new()
		remote_transform.name = "CameraFollower"
		player.add_child(remote_transform)
	remote_transform.remote_path = camera_2d.get_path()

# Level functions
func _load_level(level_number: int) -> void:
	await _fade(1.0)
	
	if current_level_node:
		current_level_node.queue_free()

	var level_path = "res://scenes/Levels/level%s.tscn" % level_number
	current_level_node = load(level_path).instantiate()
	add_child(current_level_node)
	current_level_node.name = "LevelRoot"
	_setup_level(current_level_node)
	var player = current_level_node.get_node_or_null("Player")
	
	if player:
		camera_2d.global_position = player.global_position
		camera_2d.reset_smoothing()

	await _fade(0.0)


func _setup_level(level_root: Node) -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.enemy_id in defeated_enemies:
			enemy.queue_free()

	var door_next = level_root.get_node_or_null("Door_next")
	if door_next:
		door_next.body_entered.connect(_next_door_body_entered)

	var door_previous = level_root.get_node_or_null("Door_previous")
	if door_previous:
		door_previous.body_entered.connect(_previous_door_body_entered)

	var player = level_root.get_node_or_null("Player")
	if player:
		player.inventory = player_inventory
		player.equipment = player_equipment
		player.items = player_items
		
		if not is_respawning:
			var marker_name = "SpawnNext" if travel_direction == "next" else "SpawnPrevious"
			var spawn_point = level_root.get_node_or_null(marker_name)
			if spawn_point:
				player.global_position = spawn_point.global_position
		else:
			print("Setup_level: Respawn detected, ignoring door markers.")
		_assign_camera_to_player(player)

	var trap = level_root.get_node_or_null("Floor_trap")
	if trap:
		trap.body_entered.connect(_on_trap_entered)
		trap.body_exited.connect(_on_trap_exited)

func _next_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level += 1
		travel_direction = "next"
		body.can_move = false
		_load_level(level)

func _previous_door_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		level -= 1
		travel_direction = "prev"
		body.can_move = false
		_load_level(level)


#combat
func enter_combat(enemy_node: Node2D):
	await _fade(1.0)
	active_enemy = enemy_node
	get_tree().paused = true
	
	print("Combat started with: ", enemy_node.enemy_name)
	var player = current_level_node.get_node_or_null("Player")
	#var stats = player.get_final_stats()
	
	combat_menu.setup_combat(player, enemy_node)
	combat_menu.show()
	await _fade(0.0)

func exit_combat(was_escaped: bool):
	await _fade(1.0)
	combat_menu.hide()
	get_tree().paused = false
	if was_escaped and active_enemy != null:
		if active_enemy.has_method("start_timeout"):
			active_enemy.start_timeout(1.0)

	if not was_escaped and active_enemy != null:
		defeated_enemies.append(active_enemy.enemy_id)
		active_enemy.queue_free()  
	active_enemy = null
	await _fade(0.0)

func _on_trap_entered(body):
	if body.name == "Player": player_on_trap = true

func _on_trap_exited(body):
	if body.name == "Player":
		player_on_trap = false
		trap_cooldown_timer = 0.0
		
func _take_trap_damage(player: Node2D) -> void:
	if player.name == "Player":
		var trap = current_level_node.get_node_or_null("Floor_trap")
		if trap:
			var sprite = trap.get_node_or_null("AnimatedSprite2D")
			if sprite and sprite.frame >= 5:
				player.take_damage(5)

func update_health(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, max_health)
	#_update_health_ui()
	
	if current_health <= 0:
		_player_died()

func _player_died() -> void:
	print("Player has fallen!")
	respawn_player()
	#_update_health_ui()
	

# 
func toggle_inventory() -> void:
	var player = current_level_node.get_node_or_null("Player")
	if !player: return
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		inventory_menu.update_inventory(player)
		inventory_menu.show()
	else:
		inventory_menu.hide()
		
func toggle_pause() -> void:
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		pause_menu.show()
	else:
		pause_menu.hide()


func _fill_player_inventory():
	player_inventory.append({"item_name": "golden ring", "type": "accessory", "attack_mod": 2, "health_mod": 2, "defense_mod": 2, "agility_mod": 2, "luck_mod": 2, "texture": preload("res://Assets/collectibles/armor/armor_062.png"),"description": "i can feel its power", "flag": 0})
	player_inventory.append({ "item_name": "Wooden sword", "type": "weapon", "attack_mod": 5, "health_mod": 0, "defense_mod": 0, "agility_mod": -1, "luck_mod": 0, "texture": preload("res://Assets/collectibles/wooden_sword.png"), "description": "Wooden sword", "flag": 0, "one-handed": true})
	player_inventory.append({ "item_name": "Leather helmet", "type": "head", "attack_mod": 0, "health_mod": 0, "defense_mod": 10, "agility_mod": 0, "luck_mod": 0, "texture": preload("res://Assets/collectibles/leather_helmet.png"),"description": "Basic protection for your head.", "flag": 0 })
	player_inventory.append({ "item_name": "Wooden shield", "type": "shield", "attack_mod": 0, "health_mod": 0, "defense_mod": 30, "agility_mod": 0,"luck_mod": 0, "texture": preload("res://Assets/collectibles/shield.png"),"description": "wooden shield", "flag": 0 })
	player_items.append({"item_name": "small potion", "type": "healing", "amount": 10, "texture": preload("res://Assets/collectibles/small_potions.png"), "description": "small healing potion", "flag": 1})
	player_items.append({"item_name": "medium potion", "type": "healing", "amount": 25, "texture": preload("res://Assets/collectibles/medium_potions.png"), "description": "medium healing potion", "flag": 1})
	player_items.append({"item_name": "big potion", "type": "healing", "amount": 50, "texture": preload("res://Assets/collectibles/big_potions.png"), "description": "big healing potion", "flag": 1})
	player_inventory.append({"item_name": "iron spear", "type": "weapon", "attack_mod": 10, "health_mod": 0, "defense_mod": -2, "agility_mod": -3, "luck_mod": 0, "texture": preload("res://Assets/collectibles/weapon_024.png"), "description": "iron spear", "flag": 0, "one-handed": false})

func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 0.5)
	await tween.finished
	
func save_game(pos: Vector2):
	last_save_point = pos
	saved_inventory = player_inventory.duplicate(true)
	saved_items = player_items.duplicate(true)
	saved_equipment = player_equipment.duplicate(true)
	saved_skills = learned_skills.duplicate()
	saved_health = current_health
	saved_lvl = level
	print("Game Saved at: ", pos)
	print("Level: ", saved_lvl)

func respawn_player():
	var tree = get_tree()
	is_respawning = true
	player_inventory = saved_inventory.duplicate(true)
	player_equipment = saved_equipment.duplicate(true)
	player_items = saved_items.duplicate(true)
	learned_skills = saved_skills.duplicate()
	
	current_health = saved_health
	#_load_level(saved_lvl)
	#tree.reload_current_scene()
	await tree.process_frame
	await tree.process_frame 
	var player = tree.get_first_node_in_group("player")
	if player:
		player.global_position = last_save_point
		print("Player respawned at: ", last_save_point)
		
	is_respawning = false

#func respawn_player():
	## Restore data from the save slot
	#player_inventory = saved_inventory.duplicate(true)
	#player_equipment = saved_equipment.duplicate(true)
	#learned_skills = saved_skills.duplicate()
	#current_health = saved_health
	#get_tree().reload_current_scene()
	#await get_tree().process_frame 
	#var player = get_tree().get_first_node_in_group("player")
	#if player:
		#player.global_position = last_save_point
		#_load_level(saved_lvl)
