extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var move_dir: String = "idle"
var is_moving = false
var can_move = true

func _physics_process(_delta: float) -> void:
	if can_move:
		
		var direction_x := Input.get_axis("left", "right")
		var direction_y := Input.get_axis("up", "down")
		
		velocity = Vector2.ZERO
		if direction_x != 0:
			velocity.x = direction_x * SPEED
			_animate_side()
			animated_sprite_2d.flip_h = (direction_x < 0)
		elif direction_y != 0:
			velocity.y = direction_y * SPEED
			if direction_y > 0:
				_animate_down()
			else:
				_animate_up()
		move_and_slide()
		is_moving = velocity.length() > 0
		_animate_idle()

func _animate_side() -> void:
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.animation = "running"
		move_dir = "side"


func _animate_down() -> void:
	if velocity.y > 1:
		animated_sprite_2d.animation = "down"
		move_dir = "down"

func _animate_up() -> void:
	if velocity.y < -1:
		animated_sprite_2d.animation = "up"
		move_dir = "up"
		
func _animate_idle() -> void:
	if !is_moving:
		if move_dir == "side":
			animated_sprite_2d.animation = "idle_side"
		if move_dir == "down":
			animated_sprite_2d.animation = "idle"
		if move_dir == "up":
			animated_sprite_2d.animation = "idle_up"
			
func take_damage(amount: int) -> void:
	# This looks up the tree for your Main node
	# 'get_parent().get_parent()' usually reaches Main if Player is in LevelRoot
	var main_node = get_tree().root.get_child(0) 
	if main_node.has_method("update_health"):
		main_node.update_health(-amount)
