extends Node2D
@onready var fade: ColorRect = $HUD/Fade
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var camera_2d: Camera2D = $Camera2D
@onready var health_bar: ProgressBar = $HUD/HealthBar

@onready var inventory_menu: CanvasLayer = $InventoryMenu

var level: int = 1 #starting point by default level1
var current_level_node: Node = null
var travel_direction: String = "next"
var paused = false
var max_health:int = 100
var current_health:int = 100
var player_on_trap: bool = false
var trap_cooldown_timer: float = 0.0
var TRAP_DAMAGE_DELAY: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.modulate.a = 1.0 # black screen at the beginning
	current_level_node = get_node("LevelRoot")
	_load_level(level)
	pause_menu.hide()
	_update_health_ui()
	inventory_menu.hide()

func _process(delta: float) -> void:
	if trap_cooldown_timer > 0:
		trap_cooldown_timer -= delta
	if player_on_trap and trap_cooldown_timer <= 0:
		var trap = current_level_node.get_node_or_null("Floor_trap")
		if trap:
			var sprite = trap.get_node("AnimatedSprite2D")
			# If player is on trap AND spikes are out (frame 3)
			if sprite.frame >= 6:
				update_health(-5) 
				trap_cooldown_timer = TRAP_DAMAGE_DELAY
				# Note: You'll need a timer here, or the player will die in 0.1 seconds!
					
func update_health(amount: int) -> void:
	current_health = clampi(current_health + amount, 0, max_health)
	_update_health_ui()
	
	if current_health <= 0:
		_player_died()

func _update_health_ui() -> void:
	health_bar.value = current_health

func _player_died() -> void:
	print("Player has fallen!")
	# You can trigger a game over or reload the level here
	_load_level(level) 
	current_health = max_health # Reset health
	_update_health_ui()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if inventory_menu.visible:
			toggle_inventory()
		else:
			toggle_pause()
	if event.is_action_pressed("inventory"):
		if not pause_menu.visible:
			toggle_inventory()

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

func _load_level(level_number: int) -> void:
	await _fade(1.0)
	if current_level_node:
		current_level_node.queue_free() #deletes previous level
	var level_path = "res://scenes/Levels/level%s.tscn" % level_number
	current_level_node = load(level_path).instantiate()
	add_child(current_level_node)
	current_level_node.name = "LevelRoot"
	_setup_level(current_level_node)
	var player = current_level_node.get_node_or_null("Player")
	if player:
		camera_2d.global_position = player.global_position
		camera_2d.reset_smoothing() # Prevents the "slide" if smoothing is on
	await _fade(0.0)
	
func _setup_level(level_root: Node) -> void:
	var door_next = level_root.get_node_or_null("Door_next")
	if door_next:
		door_next.body_entered.connect(_next_door_body_entered)
	
	var door_previous = level_root.get_node_or_null("Door_previous")
	if door_previous:
		door_previous.body_entered.connect(_previous_door_body_entered)
	
	var player = level_root.get_node_or_null("Player")
	var marker_name = null
	if player:
		if travel_direction == "next":
			marker_name = "SpawnNext"
		else:
			marker_name = "SpawnPrevious"
		var spawn_point = level_root.get_node_or_null(marker_name)
		if spawn_point:
			player.global_position = spawn_point.global_position
		_assign_camera_to_player(player)
		
	var trap = level_root.get_node_or_null("Floor_trap")
	if trap:
		trap.body_entered.connect(_on_trap_entered)
		trap.body_exited.connect(_on_trap_exited)

func _on_trap_entered(body):
	if body.name == "Player": player_on_trap = true

func _on_trap_exited(body):
	if body.name == "Player":
		player_on_trap = false
		trap_cooldown_timer = 0.0
		
func _take_trap_damage(player: Node2D) -> void:
	#if player.name == "Player":
		#player.take_damage(5)
	if player.name == "Player":
		# 1. Get the trap node from the level
		var trap = current_level_node.get_node_or_null("Floor_trap")
		if trap:
			# 2. Get the sprite inside the trap
			var sprite = trap.get_node_or_null("AnimatedSprite2D")
			
			# 3. Only damage if it's on a dangerous frame (e.g., frame 3 or 4)
			if sprite and sprite.frame >= 5:
				player.take_damage(5) # Using your update_health function
		
func _assign_camera_to_player(player: Node2D) -> void:
	var remote_transform = player.get_node_or_null("CameraFollower")
	if !remote_transform:
		remote_transform = RemoteTransform2D.new()
		remote_transform.name = "CameraFollower"
		player.add_child(remote_transform)
	remote_transform.remote_path = camera_2d.get_path()

# function that make visual "transition" between levels
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 0.5)
	await tween.finished


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
