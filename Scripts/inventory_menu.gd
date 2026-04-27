extends CanvasLayer

@onready var desc_label: Label = $Panel/VBoxContainer/DescLaber
@onready var title: Label = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Title
@onready var slots_tree: Tree = $Panel/VBoxContainer/HBoxContainer/Equip_Column/Slots_Tree
@onready var inventory_list: HBoxContainer = $Panel/VBoxContainer/BottomBar/ScrollContainer/InventoryList


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
#func show_item_stat_preview(new_item_data: Dictionary) -> void:
	#desc_laber.text = new_item_data.description
	#
	#_initialize_stat_previews()
	#_compare_and_preview_stat("health", new_item_data.health_mod, health_arrow)
	#_compare_and_preview_stat("attack", new_item_data.attack_mod, attack_arrow)
	#_compare_and_preview_stat("defense", new_item_data.defense_mod, defense_arrow)
	#_compare_and_preview_stat("agility", new_item_data.agility_mod, agility_arrow)
	#_compare_and_preview_stat("luck", new_item_data.luck_mod, luck_arrow)

func _populate_bottom_inventory(player: Node2D):
	# Clear previous icons
	for child in inventory_list.get_children():
		child.queue_free()
	
	for item_data in player.inventory:
		var btn = Button.new()
		btn.icon = item_data.texture
		btn.custom_minimum_size = Vector2(40, 40)
		btn.expand_icon = true
		
		# Connect selection/hover logic
		btn.mouse_entered.connect(_on_inventory_item_hover.bind(item_data))
		btn.pressed.connect(_on_inventory_item_clicked.bind(item_data))
		
		inventory_list.add_child(btn)

var selected_inventory_item = null

func _on_inventory_item_hover(data):
	desc_label.text = data.description
	_show_stat_comparison(data)

func _on_inventory_item_clicked(data):
	selected_inventory_item = data
	# Highlight the item or show it's ready to equip

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
	var hlth_diff = new_item.health_mod - (current_equip.health_mod_mod if current_equip else 0)
	var agl_diff = new_item.agility_mod - (current_equip.agility_mod if current_equip else 0)
	var lck_diff = new_item.luck_mod - (current_equip.luck_mod if current_equip else 0)
	
	_compare_and_preview_stat("attack", atk_diff, attack_preview)
	_compare_and_preview_stat("defense", def_diff, defense_preview)
	_compare_and_preview_stat("health", hlth_diff, health_preview)
	_compare_and_preview_stat("agility", agl_diff, agility_preview)
	_compare_and_preview_stat("luck", lck_diff, luck_preview)
	# ... repeat for other stats

#func _compare_and_preview_stat(stat_name: String, item_mod: int, preview_label: Label):
	## Get the current value from the player [cite: 10]
	#var current_val = player_node.get_final_stats()[stat_name]
	#
	## Logic: Compare new item mod against what is CURRENTLY equipped in that slot
	#var current_equip = player_node.equipment.get(selected_inventory_item.type)
	#var current_mod = current_equip.get(stat_name + "_mod", 0) if current_equip else 0
	#
	## The difference is (New Item Mod - Old Item Mod)
	#var diff = item_mod - current_mod
	#var final_preview_val = current_val + diff
#
	#if diff > 0:
		#preview_label.text = " -> " + str(final_preview_val)
		#preview_label.add_theme_color_override("font_color", Color.GREEN)
		#preview_label.show()
	#elif diff < 0:
		#preview_label.text = " -> " + str(final_preview_val)
		#preview_label.add_theme_color_override("font_color", Color.RED)
		#preview_label.show()
	#else:
		#preview_label.hide()
		#
		
func _compare_and_preview_stat(stat_name: String, item_mod: int, preview_label: Label):
	# 1. Safety check: if no item is being hovered/selected, don't calculate
	if selected_inventory_item == null:
		preview_label.hide()
		return
		
	# 2. Get the current stats from the player
	var current_val = player_node.get_final_stats()[stat_name]
	
	# 3. Safe access to the currently equipped item in that specific slot
	var slot_type = selected_inventory_item.get("type", "")
	var current_equip = player_node.equipment.get(slot_type)
	
	# 4. Get the mod of the current equipment (0 if nothing is equipped)
	var current_mod = 0
	if current_equip:
		current_mod = current_equip.get(stat_name + "_mod", 0)
	
	# 5. Calculate the difference
	var diff = item_mod - current_mod
	var final_preview_val = current_val + diff

	# 6. UI Update
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
	
	# Perform the swap on the player
	var type = selected_inventory_item.type
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
