extends Node2D
@onready var fade: ColorRect = $HUD/Fade

var level: int = 1 #starting point by default level1
var current_level_node: Node = null
var travel_direction: String = "next"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fade.modulate.a = 1.0 # black screen at the beginning
	current_level_node = get_node("LevelRoot")
	_load_level(level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _load_level(level_number: int) -> void:
	await _fade(1.0)
	if current_level_node:
		current_level_node.queue_free() #deletes previous level
	var level_path = "res://scenes/Levels/level%s.tscn" % level_number
	current_level_node = load(level_path).instantiate()
	add_child(current_level_node)
	current_level_node.name = "LevelRoot"
	_setup_level(current_level_node)
	
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
			
			
	
# function that make visual "transition" between levels
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
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
