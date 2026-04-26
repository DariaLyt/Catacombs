extends CanvasLayer

@onready var desc_label: Label = $Panel/VBoxContainer/DescLaber
@onready var title: Label = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Title
#@onready var slots_tree: ItemList = $Panel/VBoxContainer/HBoxContainer/Equip_Column/Slots_Tree
@onready var slots_tree: Tree = $Panel/VBoxContainer/HBoxContainer/Equip_Column/Slots_Tree
@onready var inventory_list: HBoxContainer = $Panel/VBoxContainer/BottomBar/ScrollContainer/InventoryList


@onready var health_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Health_Stat/StatValue
@onready var health_arrow = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Health_Stat/Arrow

@onready var attack_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Attack_Stat/StatValue
@onready var attack_arrow = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Attack_Stat/Arrow

@onready var defense_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Defense_Stat/StatValue
@onready var defense_arrow = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Defense_Stat/Arrow

@onready var agility_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Agility_Stat/StatValue
@onready var agility_arrow = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Agility_Stat/Arrow

@onready var luck_val = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Luck_Stat/StatValue
@onready var luck_arrow = $Panel/VBoxContainer/HBoxContainer/Stats_Column/Luck_Stat/Arrow

var player_node: Node2D = null
var current_stats: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots_tree.set_column_title(0, "Type")
	slots_tree.set_column_title(1, "Name")
	_initialize_stat_previews()

func _initialize_stat_previews():
	health_arrow.hide()
	attack_arrow.hide()
	defense_arrow.hide()
	agility_arrow.hide()
	luck_arrow.hide()
	
func update_inventory(player: Node2D) -> void:
	player_node = player
	current_stats = player.get_final_stats()
	_display_current_stats()
	_populate_equipment_slots(player)
	_populate_bottom_inventory(player)
	_reset_item_view()

func _display_current_stats():
	title.text = "Player Stats"
	health_val.text = str(current_stats.health)
	attack_val.text = str(current_stats.attack)
	defense_val.text = str(current_stats.defense)
	agility_val.text = str(current_stats.agility)
	luck_val.text = str(current_stats.luck)
	
#func _populate_equipment_slots(player: Node2D):
	#slots_tree.clear()
	#var root = slots_tree.create_item()
	#var slots = player.get_equipment_slots()
	#
	#for slot_type in slots.keys():
		#var item = slots_tree.create_item(root)
		#item.set_text(0, slot_type.capitalize())
		#if slots[slot_type]:
			#item.set_text(1, slots[slot_type].item_name)
		#else:
			#item.set_text(1, "Empty")
			
#func _populate_equipment_slots(player: Node2D):
	#slots_tree.clear()
	#var root = slots_tree.create_item()
	#slots_tree.hide_root = true
	#
	#var equip_catetory = slots_tree.create_item(root)
	#equip_catetory.set_text(0, "EQUIPPED")
	#equip_catetory.set_selectable(0, false)
	#
	#for slot_type in player.equipment.keys():
		#var item_node = slots_tree.create_item(equip_catetory)
		#var equipped_item = player.equipment[slot_type]
		#item_node.set_text(0, slot_type.capitalize())
		#if equipped_item:
			#item_node.set_text(1, equipped_item.item_name)
			#item_node.set_icon(1, equipped_item.texture)
		#else:
			#item_node.set_text(1, "Empty")
			#
	#var inv_category = slots_tree.create_item(root)
	#inv_category.set_text(0, "Inventory")
	#inv_category.set_selectable(0, false)
	#for item_data in player.inventory:
		#var item_node = slots_tree.create_item(inv_category)
		#item_node.set_text(0, item_data.type.capitalize())
		#item_node.set_text(1, item_data.item_name)
		#item_node.set_icon(1, item_data.texture)
		#item_node.set_metadata(0, item_data)
		
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
	
	_compare_and_preview_stat("attack", atk_diff, attack_arrow)
	_compare_and_preview_stat("defense", def_diff, defense_arrow)
	_compare_and_preview_stat("health", hlth_diff, health_arrow)
	_compare_and_preview_stat("agility", agl_diff, agility_arrow)
	_compare_and_preview_stat("luck", lck_diff, luck_arrow)
	# ... repeat for other stats

func _compare_and_preview_stat(stat_name: String, item_mod: int, arrow_node: TextureRect):
	if !current_stats.has(stat_name): return
	
	if item_mod > 0:
		arrow_node.texture = preload("res://ui/arrow-top.png")
		arrow_node.show()
	elif item_mod < 0:
		arrow_node.texture = preload("res://ui/arrow-bottom.png")
		arrow_node.show()
	else:
		arrow_node.hide()
		
func _reset_item_view():
	desc_label.text = "Select an item to see its properties."
	_initialize_stat_previews()


func _on_equip_pressed() -> void:
	if not selected_inventory_item: return
	
	var type = selected_inventory_item.type
	var old_item = player_node.equipment[type]
	
	# Swap items
	player_node.equipment[type] = selected_inventory_item
	player_node.inventory.erase(selected_inventory_item)
	
	# Put the old gear back into the bottom bar
	if old_item:
		player_node.inventory.append(old_item)
	
	selected_inventory_item = null
	update_inventory(player_node) # Refresh everything
