extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var enemy_id: String = ""
@export var speed: float = 80.0
@export var chase_speed: float = 90.0
@export var enemy_name: String = "skeleton"
@export var health_amount: int = 100
@export var damage_amount: int = 25

var player: CharacterBody2D = null
var current_direction: Vector2 = Vector2.RIGHT
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var is_stunned: bool = false

func _ready():
	pick_random_direction()
	
func _physics_process(_delta:float):
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
		
	_update_animations()

func _update_animations():
	if current_direction == Vector2.UP:
		animated_sprite_2d.animation = "up"
	elif current_direction == Vector2.DOWN:
		animated_sprite_2d.animation = "down"
	elif current_direction == Vector2.RIGHT:
		animated_sprite_2d.animation = "right"
	else :
		animated_sprite_2d.animation = "left"

func start_timeout(duration: float):
	is_stunned = true
	#animated_sprite_2d.stop() # Optional: stop the walking animation
	await get_tree().create_timer(duration).timeout
	is_stunned = false

func trigger_combat():
	var main_node = get_tree().root.get_child(0)
	if main_node.has_method("enter_combat"):
		main_node.enter_combat(self)

func pick_random_direction():
	current_direction = directions.pick_random()


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		player = body
		#add_collision_exception_with(body)
	

func _on_area_2d_body_exited(body) -> void:
	if body == player:
		#remove_collision_exception_with(player)
		player = null
		pick_random_direction()
