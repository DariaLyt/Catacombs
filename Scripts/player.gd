extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var move_dir: String = "idle"
var is_moving = false
var can_move = true

func _physics_process(_delta: float) -> void:
	if can_move:
	# Get the input direction and handle the movement/deceleration.
		var direction_x := Input.get_axis("left", "right")
		if direction_x:
			velocity.x = direction_x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		var direction_y := Input.get_axis("up", "down")
		if direction_y:
			velocity.y = direction_y * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)
		_animate_side()
		
		if direction_x == 1.0:
			
			animated_sprite_2d.flip_h = false
		if direction_x == -1.0:
			#_animate_side()
			animated_sprite_2d.flip_h = true
			
		if direction_y == 1.0:
			_animate_down()
		if direction_y == -1.0:
			_animate_up()
		move_and_slide()
		_animate_idle()

func _animate_side() -> void:
	if velocity.x > 1 or velocity.x < -1:
		is_moving = true
		animated_sprite_2d.animation = "running"
		move_dir = "side"
	else:
		is_moving = false


func _animate_down() -> void:
	if velocity.y > 1:
		is_moving = true
		animated_sprite_2d.animation = "down"
		move_dir = "down"
	else:
		is_moving = false

func _animate_up() -> void:
	if velocity.y < -1:
		is_moving = true
		animated_sprite_2d.animation = "up"
		move_dir = "up"
	else:
		is_moving = false
		
func _animate_idle() -> void:
	if !is_moving:
		if move_dir == "side":
			animated_sprite_2d.animation = "idle_side"
		if move_dir == "down":
			animated_sprite_2d.animation = "idle"
		if move_dir == "up":
			animated_sprite_2d.animation = "idle_up"
