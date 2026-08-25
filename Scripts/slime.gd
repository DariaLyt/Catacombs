extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var enemy_id: String = ""
@export var speed: float = 55.0
@export var chase_speed: float = 70.0
@export var enemy_name: String = "slime"
@export var health_amount: int = 45
@export var damage_amount: int = 8

var player: CharacterBody2D = null
var current_direction: Vector2 = Vector2.RIGHT
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var is_stunned: bool = false

func _ready() -> void:
	pick_random_direction()

func _physics_process(_delta: float) -> void:
	if is_stunned:
		velocity = Vector2.ZERO
		return

	if player:
		velocity = (player.global_position - global_position).normalized() * chase_speed
	else:
		velocity = current_direction * speed

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			trigger_combat()

	if get_slide_collision_count() > 0 and not player:
		pick_random_direction()

	if velocity.length() > 0:
		animated_sprite_2d.play("down")

func start_timeout(duration: float) -> void:
	is_stunned = true
	await get_tree().create_timer(duration).timeout
	is_stunned = false

func trigger_combat() -> void:
	var main_node = get_tree().get_first_node_in_group("game_main")
	if main_node.has_method("enter_combat"):
		main_node.enter_combat(self)

func pick_random_direction() -> void:
	current_direction = directions.pick_random()

func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		player = body

func _on_area_2d_body_exited(body) -> void:
	if body == player:
		player = null
		pick_random_direction()
