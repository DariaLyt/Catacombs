extends CanvasLayer

@onready var health_value_label: Label = $HBoxContainer/Stats/HealthBar/VBoxContainer/HBoxContainer/Value
@onready var health_bar: ProgressBar = $HBoxContainer/Stats/HealthBar/VBoxContainer/HealthBar
@onready var enemy_to_fight: AnimatedSprite2D = $enemy
@onready var stats: VBoxContainer = $HBoxContainer/Stats
@onready var skill_tree: Tree = $HBoxContainer/Skills
@onready var description: Panel = $description
@onready var label: Label = $description/Label
@onready var items: Tree = $HBoxContainer/Items


var player_node: Node2D = null
var current_enemy_hp: int
var current_enemy_attack: int
var skills_description = {
	"Talk": "Talking can sometimes get you out of uncomfortable situations.",
	"Run": "There is no shame in running from battles to live another day.",
	"Steal": "Steal from the rich and give to yourself.",
	"Escape plan": "A skill that greatly enhances your chances for running away from fights."
	
}
var current_player_hp: int
enum Turn {PLAYER, ENEMY, BUSY}
var current_turn = Turn.PLAYER
var is_guarding: bool = false
var enemy_node: Node2D

func _ready():
	# Hide the skill tree by default
	stats.show()
	skill_tree.hide()
	description.hide()
	items.hide()
	#_setup_skill_tree()

func _setup_skill_tree():
	skill_tree.clear()
	skill_tree.hide_root = true
	skill_tree.columns = 2
	var root = skill_tree.create_item()
	var main_node = get_tree().root.get_child(0)
	var skills = main_node.learned_skills
	var current_row = null
	for i in range(skills.size()):
		var skill_name = skills[i]
		var skill_data = main_node.master_skills[skill_name]
		var column = i % 2
		if column == 0:
			current_row = skill_tree.create_item(root)
		current_row.set_text(column, " " + skill_name)
		current_row.set_metadata(column, skill_name)
		if skill_data.has("icon"):
			current_row.set_icon(column, load(skill_data["icon"]))
	
func setup_combat(player:Node2D, enemy: Node2D):
	enemy_node = enemy
	player_node = player
	var main_node = get_tree().root.get_child(0)
	var current_enemy_name = enemy.enemy_name
	enemy_to_fight.animation = current_enemy_name
	current_player_hp = main_node.current_health
	health_value_label.text = str(current_player_hp)
	health_bar.value = current_player_hp
	
	current_enemy_hp = enemy.health_amount
	current_enemy_attack = enemy.damage_amount

	current_turn = Turn.PLAYER
	_update_ui_state()
	_setup_skill_tree()
	#$TextureRect.texture = enemy.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle", 0)


func _update_ui_state():
	var is_player_turn = (current_turn == Turn.PLAYER)
	$HBoxContainer/Action/Attack.disabled = !is_player_turn
	$HBoxContainer/Action/Guard.disabled = !is_player_turn
	$HBoxContainer/Action/Skill.disabled = !is_player_turn
	$HBoxContainer/Action/Item.disabled = !is_player_turn
	
func _on_attack_pressed():
	if current_turn != Turn.PLAYER: return
	current_turn = Turn.BUSY
	
	if skill_tree.visible:
		description.hide()
		items.hide()
		skill_tree.hide()
		stats.show()
		
	var player_atk = player_node.get_final_stats()["attack"]
	var roll = randf_range(0, 100)
	var is_crit = roll < player_node.get_final_stats()["luck"]
	if is_crit:
		current_enemy_attack = current_enemy_attack - (player_atk * 2)
	else:
		current_enemy_hp -= player_atk
	print("Player attacks for ", player_atk)
	# Check for enemy death
	if current_enemy_hp <= 0:
		_on_victory()
	else:
		await get_tree().create_timer(0.8).timeout
		_start_enemy_turn()
	print("Player attacks!")
	print("Enemy Stats Loaded -> HP: ", current_enemy_hp, " ATK: ", current_enemy_attack)
	#get_tree().quit()
	# Calculate damage using player_stats["attack"]

func _on_victory():
	current_turn = Turn.BUSY
	print("Victory!")
	await get_tree().create_timer(1.5).timeout
	var main_node = get_tree().root.get_child(0)
	main_node.exit_combat(false) 

func _on_defeat():
	current_turn = Turn.BUSY
	print("Defeated...")
	$ColorRect.color = Color(0.5, 0, 0, 0.5)
	await get_tree().create_timer(0.5).timeout
	var main_node = get_tree().root.get_child(0)
	main_node.exit_combat(true)
	main_node.respawn_player()
	#sget_tree().reload_current_scene()
	
func _on_skill_pressed():
	if stats.visible:
		stats.hide()
		description.show()
		skill_tree.show()

func _on_skills_item_selected() -> void:
	var selected = skill_tree.get_selected()
	var col = skill_tree.get_selected_column()
	var skill_name = selected.get_metadata(col)
	var main_node = get_tree().root.get_child(0)
	
	match skill_name:
		"Escape plan":
			main_node.exit_combat(true)
			return 
		"Talk":
			print("enemy doesnt understand you")
	skill_tree.hide()
	description.hide()
	stats.show()
	_start_enemy_turn()
	
	#var selected = skill_tree.get_selected()
	#var col = skill_tree.get_selected_column()
	#var skill_name = selected.get_text(col).strip_edges()
	#var main_node = get_tree().root.get_child(0)
	#print("Selected Skill: ", skill_name)
	#if skill_name == "Talk":
		#print("enemy doesnt understand you")
		#_start_enemy_turn()
	#if skill_name == "Escape plan":
		#main_node.exit_combat(true)
	#skill_tree.hide()
	#description.hide()
	#stats.show()
	
func _on_skills_mouse_exited() -> void:
	label.text = ""

func _on_skills_gui_input(_event: InputEvent) -> void:
	var mouse_pos = skill_tree.get_local_mouse_position()
	var item = skill_tree.get_item_at_position(mouse_pos)
	
	if item:
		var col = 0 if mouse_pos.x < (skill_tree.size.x / 2) else 1
		
		var skill_name = item.get_metadata(col)
		if skill_name and skills_description.has(skill_name):
			label.text = skills_description[skill_name]
			return

	label.text = "Select a skill..."


func _on_guard_pressed() -> void:
	if current_turn != Turn.PLAYER: return
	current_turn = Turn.BUSY
	print("Player is guarding!")
	# We will handle the damage reduction in the enemy turn logic
	is_guarding = true 
	await get_tree().create_timer(0.5).timeout
	_start_enemy_turn()


func _start_enemy_turn():
	current_turn = Turn.ENEMY
	_update_ui_state()
	print("Enemy's Turn...")
	await get_tree().create_timer(1.0).timeout # Enemy "thinking" time
	var damage = current_enemy_attack
	
	if is_guarding:
		var dodge = randf_range(0, 100)
		if dodge < player_node.get_final_stats()["agility"]:
			damage = 0
			current_turn = Turn.PLAYER
			
			is_guarding = false
			return
		
	var base_damage = current_enemy_attack - (player_node.get_final_stats()["defense"] / 3.0)
	damage = max(1, int(base_damage))
	if is_guarding:
		damage = ceil(damage * 0.5) 
		is_guarding = false
		print("Guard reduced damage!")

	current_player_hp -= damage
	health_value_label.text = str(current_player_hp)
	health_bar.value = current_player_hp
	var main_node = get_tree().root.get_child(0)
	main_node.current_health = current_player_hp
	
	if current_player_hp <= 0:
		_on_defeat()
	else:
		current_turn = Turn.PLAYER
		_update_ui_state()


func _on_item_pressed() -> void:
	skill_tree.hide()
	stats.hide()
	items.show()
	description.show()
	_populate_item_list()
	
func _populate_item_list():
	items.clear()
	items.hide_root = true
	items.columns = 2
	var root = items.create_item()
	
	var inv = player_node.items
	var current_row = null
	print(inv.size())
	for i in range(inv.size()):
		var item_data = inv[i]
		var column = i % 2
		if column == 0:
			current_row = items.create_item(root)
			
		current_row.set_text(column, " " + item_data.get("item_name"))
		current_row.set_icon(column, item_data.get("texture", null))
		current_row.set_metadata(column, item_data)
		current_row.set_selectable(column, true)

func _on_items_item_activated() -> void:
	var selected = items.get_selected()
	var col = items.get_selected_column()
	var item_data = selected.get_metadata(col)
	
	if item_data:
		if item_data.has("amount") and item_data["amount"] > 0:
			current_player_hp = min(100, current_player_hp + item_data["amount"])
			health_value_label.text = str(current_player_hp)
			health_bar.value = current_player_hp
		print("Used item: ", item_data["item_name"])
		player_node.items.erase(item_data)
		
	description.hide()
	items.hide()
	stats.show()
	_start_enemy_turn()
