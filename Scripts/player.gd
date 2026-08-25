extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var move_dir: String = "idle"
var is_moving = false
var can_move = true

var base_health = 100
var base_attack = 20
var base_defense = 0
var base_agility = 10
var base_luck = 5

var inventory = []
var equipment = {}
var items = []

func _ready() -> void:
	set_collision_layer_value(1, true)
	set_collision_mask_value(3, false)
	
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
	var main_node = get_tree().get_first_node_in_group("game_main") 
	if main_node.has_method("update_health"):
		main_node.update_health(-amount)

func get_final_stats() -> Dictionary:
	var main_node = get_tree().get_first_node_in_group("game_main")
	var hp = main_node.current_health if main_node else base_health
	
	var final = { 
		"health": hp, 
		"attack": base_attack, 
		"defense": base_defense, 
		"agility": base_agility, 
		"luck": base_luck 
	}
	
	for slot in equipment.values():
		if slot:
			final.health += slot.get("health_mod", 0)
			final.attack += slot.get("attack_mod", 0)
			final.defense += slot.get("defense_mod", 0)
			final.agility += slot.get("agility_mod", 0)
			final.luck += slot.get("luck_mod", 0)
	
	return final
	
func get_equipment_slots() -> Dictionary:
	return equipment

func learn_skill(skill_name: String):
	var main_node = get_tree().get_first_node_in_group("game_main")
	if not main_node.learned_skills.has(skill_name):
		main_node.learned_skills.append(skill_name)
		print("New skill learned: ", skill_name)
