extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


#@export var speed: float = 80.0
#@export var chase_speed: float = 90.0
@export var enemy_id: String = ""
@export var enemy_name: String = "goblin"
@export var health_amount: int = 50
@export var damage_amount: int = 8


var player: CharacterBody2D = null
var is_stunned: bool = false

func _physics_process(_delta: float) -> void:
	if is_stunned:
		velocity = Vector2.ZERO
		#move_and_slide() # Still call this so it can be pushed, but with zero velocity [cite: 2]
		return

func start_timeout(duration: float):
	is_stunned = true
	#animated_sprite_2d.stop() # Optional: stop the walking animation
	await get_tree().create_timer(duration).timeout
	is_stunned = false

func trigger_combat():
	var main_node = get_tree().get_first_node_in_group("game_main")
	if main_node.has_method("enter_combat"):
		main_node.enter_combat(self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		trigger_combat()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		
