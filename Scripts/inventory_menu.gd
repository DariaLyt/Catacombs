extends CanvasLayer

@onready var desc_label: Label = $Panel/VBoxContainer/DescLaber
@onready var title: Label = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Title
@onready var slots_tree: Tree = $Panel/VBoxContainer/HBoxContainer/Equip_Column/Slots_Tree
@onready var inventory_list: HBoxContainer = $Panel/VBoxContainer/BottomBar/ScrollContainer/InventoryList
@onready var scroll_container: ScrollContainer = $Panel/VBoxContainer/BottomBar/ScrollContainer
@onready var item_container: ScrollContainer = $Panel/VBoxContainer/BottomBar/ItemContainer
@onready var items_list: HBoxContainer = $Panel/VBoxContainer/BottomBar/ItemContainer/ItemsList


@onready var health_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Health_Stat/StatValue
@onready var health_preview = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Health_Stat/StatPreview

@onready var attack_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Attack_Stat/StatValue
@onready var attack_preview = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Attack_Stat/StatPreview

@onready var defense_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Defense_Stat/StatValue
@onready var defense_preview = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Defense_Stat/StatPreview

@onready var agility_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Agility_Stat/StatValue
@onready var agility_preview = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Agility_Stat/StatPreview

@onready var luck_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Luck_Stat/StatValue
@onready var luck_preview = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Luck_Stat/StatPreview

var player_node: Node2D = null
var current_stats: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots_tree.set_column_title(0, "Type")
	slots_tree.set_column_title(1, "Name")
	scroll_container.show()
	item_container.hide()
	_initialize_stat_previews()

func _initialize_stat_previews():
	health_preview.hide()
	attack_preview.hide()
	defense_preview.hide()
	agility_preview.hide()
	luck_preview.hide()
	
func update_inventory(player: Node2D) -> void:
	player_node = player
	current_stats = player.get_final_stats()
	_display_current_stats()
	_populate_equipment_slots(player)
	_populate_bottom_inventory(player)
	_reset_item_view()

func _display_current_stats():
	var stats = player_node.get_final_stats()
	# Assuming your Labels are named accordingly:
	health_val.text = str(stats.health)
	attack_val.text = str(stats.attack)
	defense_val.text = str(stats.defense)
	agility_val.text = str(stats.agility)
	luck_val.text = str(stats.luck)
	
func _populate_equipment_slots(player: Node2D):
	slots_tree.clear()
	var root = slots_tree.create_item()
	slots_tree.hide_root = true
	
	for slot_type in player.equipment.keys():
		var item_node = slots_tree.create_item(root)
		var equipped_item = player.equipment[slot_type]
		item_node.set_text(0, slot_type.capitalize())
		
		if equipped_item:
			item_node.set_text(1, equipped_item.item_name)
			item_node.set_icon(1, equipped_item.texture)
		else:
			item_node.set_text(1, "Empty")



func _populate_bottom_inventory(player: Node2D):
	# Clear previous icons
	for child in inventory_list.get_children():
		child.queue_free()
	
	for item_data in player.inventory:
		var btn = Button.new()
		btn.icon = item_data.texture
		btn.custom_minimum_size = Vector2(60, 60)
		btn.expand_icon = true
		
		# Connect selection/hover logic
		btn.mouse_entered.connect(_on_inventory_item_hover.bind(item_data))
		btn.pressed.connect(_on_inventory_item_clicked.bind(item_data))
		inventory_list.add_child(btn)
	
	for child in items_list.get_children():
		child.queue_free()
	
	for item_data in player.items:
		var btn = Button.new()
		btn.icon = item_data.texture
		btn.custom_minimum_size = Vector2(60, 60)
		btn.expand_icon = true
		
		# Connect selection/hover logic
		btn.mouse_entered.connect(_on_inventory_item_hover.bind(item_data))
		btn.pressed.connect(_on_inventory_item_clicked.bind(item_data))
		items_list.add_child(btn)

var selected_inventory_item = null

func _on_inventory_item_hover(item_data: Dictionary):
	selected_inventory_item = item_data
	desc_label.text = item_data.get("description", "")
	var flag = item_data.get("flag")
	if flag == 0:
		_show_stat_comparison(item_data)


func _on_inventory_item_clicked(data):
	var flag = data.get("flag")
	if flag == 1:
		_use_player_item()
	selected_inventory_item = data

func _use_player_item():
	if not selected_inventory_item: return
	var type = selected_inventory_item.get("type")
	var main_node = get_tree().root.get_child(0)
	if type == "book":
		print("book")
		var skill_to_learn = selected_inventory_item.get("unlocks_skill")
		if skill_to_learn:
			player_node.learn_skill(skill_to_learn)
			player_node.items.erase(selected_inventory_item)
			main_node.player_items = player_node.items
			selected_inventory_item = null
			update_inventory(player_node)
	else:
		var amount = selected_inventory_item.get("amount")
		print(amount)
		player_node.items.erase(selected_inventory_item)
		main_node.player_items = player_node.items
		if type == "healing":
			main_node.update_health(amount)
		elif type == "attack":
			print("attack boost")
		elif type == "defense":
			print("defense")
		selected_inventory_item = null
		update_inventory(player_node)
	

func _on_slots_tree_item_selected():
	var selected_item = slots_tree.get_selected()
	var data = selected_item.get_metadata(0)
	if data:
		desc_label.text = data.description
		_show_stat_comparison(data)

func _show_stat_comparison(new_item: Dictionary):
	_initialize_stat_previews()

	var current_equip = player_node.equipment.get(new_item.type)
	
	# Calculate the difference
	var atk_diff = new_item.attack_mod - (current_equip.attack_mod if current_equip else 0)
	var def_diff = new_item.defense_mod - (current_equip.defense_mod if current_equip else 0)
	var hlth_diff = new_item.health_mod - (current_equip.health_mod if current_equip else 0)
	var agl_diff = new_item.agility_mod - (current_equip.agility_mod if current_equip else 0)
	var lck_diff = new_item.luck_mod - (current_equip.luck_mod if current_equip else 0)
	
	_compare_and_preview_stat("attack", atk_diff, attack_preview)
	_compare_and_preview_stat("defense", def_diff, defense_preview)
	_compare_and_preview_stat("health", hlth_diff, health_preview)
	_compare_and_preview_stat("agility", agl_diff, agility_preview)
	_compare_and_preview_stat("luck", lck_diff, luck_preview)


func _compare_and_preview_stat(stat_name: String, item_mod: int, preview_label: Label):
	if selected_inventory_item == null:
		preview_label.hide()
		return
	var current_val = player_node.get_final_stats()[stat_name]

	var slot_type = selected_inventory_item.get("type", "")
	var current_equip = player_node.equipment.get(slot_type)
	
	var current_mod = 0
	if current_equip:
		current_mod = current_equip.get(stat_name + "_mod", 0)
	
	var diff = item_mod - current_mod
	var final_preview_val = current_val + diff

	if diff != 0:
		preview_label.text = " -> " + str(final_preview_val)
		if diff > 0:
			preview_label.add_theme_color_override("font_color", Color.GREEN)
		else:
			preview_label.add_theme_color_override("font_color", Color.RED)
		preview_label.show()
	else:
		preview_label.hide()

func _reset_item_view():
	desc_label.text = "Select an item to see its properties."
	_initialize_stat_previews()


func _on_equip_pressed():
	if not selected_inventory_item: return
	
	var type = selected_inventory_item.type
	var is_two_handed = selected_inventory_item.get("one-handed", true) == false
	if type == "shield":
		var current_weapon = player_node.equipment.get("weapon")
		if current_weapon and current_weapon.get("one-handed", true) == false:
			print("Cannot equip shield with a two-handed weapon!")
			return # Exit the function early

	if type == "weapon" and is_two_handed:
		var current_shield = player_node.equipment.get("shield")
		if current_shield:
			player_node.inventory.append(current_shield)
			player_node.equipment["shield"] = null
			print("Unequipped shield to hold two-handed weapon.")
	var old_item = player_node.equipment[type]
	player_node.equipment[type] = selected_inventory_item
	player_node.inventory.erase(selected_inventory_item)
	
	if old_item:
		player_node.inventory.append(old_item)
	
	var main_node = get_tree().root.get_child(0)
	main_node.player_inventory = player_node.inventory
	main_node.player_equipment = player_node.equipment
	
	selected_inventory_item = null
	update_inventory(player_node)


func _on_equipment_pressed() -> void:
	print("equipment presssed")
	item_container.hide()
	scroll_container.show()


func _on_items_pressed() -> void:
	print("items pressed")
	item_container.show()
	scroll_container.hide()
