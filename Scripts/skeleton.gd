extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var speed: float = 80.0
@export var chase_speed: float = 90.0
@export var damage_amount: int = 10
@export var attack_cooldown: float = 1.5

var player: CharacterBody2D = null
var current_direction: Vector2 = Vector2.RIGHT
var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
var attack_timer: float = 0.0
var is_stunned: bool = false

func _ready():
	pick_random_direction()
	
func _physics_process(delta:float):
	if is_stunned:
		velocity = Vector2.ZERO
		move_and_slide() # Still call this so it can be pushed, but with zero velocity [cite: 2]
		return

	if attack_timer > 0:
		attack_timer -= delta
	if player:
		var dist = global_position.distance_to(player.global_position)
		
		# If we are super close (attacking), stop being a physical wall
		if dist < 30:
			set_collision_mask_value(1, false) # Stop looking for Player/Walls
		else:
			set_collision_mask_value(1, true) # Become solid again
			
		velocity = (player.global_position - global_position).normalized() * chase_speed
		
		#if dist < 40 and attack_timer <= 0:
			#attack_player()
	else:
		velocity = current_direction * speed
	
	var collided = move_and_slide()
	
	if collided:
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider().name == "Player":
				trigger_combat()
	if collided and not player:
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
	

func _on_area_2d_body_exited(body) -> void:
	if body == player:
		player = null
		pick_random_direction()
