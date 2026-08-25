extends Node

## Global quest state. Loaded from data/quests.json — not tied to level scenes.
signal quest_started(quest_id: String)
signal quest_updated(quest_id: String)
signal quest_completed(quest_id: String)

const DATA_PATH := "res://data/quests.json"

var _definitions: Dictionary = {}
var active_quests: Dictionary = {}
var completed_quests: Array[String] = []
var read_journals: Array[String] = []


func _ready() -> void:
	_load_definitions()


func _load_definitions() -> void:
	var file := FileAccess.open(DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("QuestManager: cannot open %s" % DATA_PATH)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("QuestManager: invalid quest data")
		return
	_definitions = parsed


func get_quest_def(quest_id: String) -> Dictionary:
	return _definitions.get("quests", {}).get(quest_id, {})


func get_journal(journal_id: String) -> Dictionary:
	return _definitions.get("journals", {}).get(journal_id, {})


func get_npc(npc_id: String) -> Dictionary:
	return _definitions.get("npcs", {}).get(npc_id, {})


func is_active(quest_id: String) -> bool:
	return active_quests.has(quest_id)


func is_complete(quest_id: String) -> bool:
	return quest_id in completed_quests


func start_quest(quest_id: String) -> void:
	if is_complete(quest_id) or is_active(quest_id):
		return
	if get_quest_def(quest_id).is_empty():
		push_warning("QuestManager: unknown quest '%s'" % quest_id)
		return
	active_quests[quest_id] = {"step": 0}
	quest_started.emit(quest_id)
	quest_updated.emit(quest_id)


func complete_objective(quest_id: String, objective_id: String = "") -> void:
	if not is_active(quest_id):
		return
	var def: Dictionary = get_quest_def(quest_id)
	var objectives: Array = def.get("objectives", [])
	var step: int = int(active_quests[quest_id].get("step", 0))
	if objective_id.is_empty():
		step += 1
	else:
		for i in objectives.size():
			if str(objectives[i].get("id", "")) == objective_id:
				step = max(step, i + 1)
				break
	active_quests[quest_id]["step"] = step
	if step >= objectives.size():
		complete_quest(quest_id)
	else:
		quest_updated.emit(quest_id)


func complete_quest(quest_id: String) -> void:
	if not is_active(quest_id):
		return
	active_quests.erase(quest_id)
	if quest_id not in completed_quests:
		completed_quests.append(quest_id)
	quest_completed.emit(quest_id)
	quest_updated.emit(quest_id)


func get_current_objective_text(quest_id: String) -> String:
	if not is_active(quest_id):
		return ""
	var def: Dictionary = get_quest_def(quest_id)
	var objectives: Array = def.get("objectives", [])
	var step: int = int(active_quests[quest_id].get("step", 0))
	if step >= objectives.size():
		return "Complete."
	return str(objectives[step].get("text", ""))


func get_tracker_lines(max_lines: int = 2) -> PackedStringArray:
	var lines: PackedStringArray = []
	var mains: Array[String] = []
	var sides: Array[String] = []
	for quest_id in active_quests.keys():
		var def: Dictionary = get_quest_def(quest_id)
		if def.is_empty():
			continue
		var line := "%s: %s" % [def.get("title", quest_id), get_current_objective_text(quest_id)]
		if def.get("type", "") == "main":
			mains.append(line)
		else:
			sides.append(line)
	for line in mains:
		if lines.size() >= max_lines:
			break
		lines.append(line)
	for line in sides:
		if lines.size() >= max_lines:
			break
		lines.append(line)
	return lines


func get_quest_log_entries() -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	for quest_id in active_quests.keys():
		var def: Dictionary = get_quest_def(quest_id)
		if def.is_empty():
			continue
		entries.append({
			"id": quest_id,
			"title": def.get("title", quest_id),
			"status": "active",
			"objective": get_current_objective_text(quest_id),
			"type": def.get("type", "side"),
			"act": def.get("act", 0),
		})
	for quest_id in completed_quests:
		var def: Dictionary = get_quest_def(quest_id)
		if def.is_empty():
			continue
		entries.append({
			"id": quest_id,
			"title": def.get("title", quest_id),
			"status": "complete",
			"objective": "Completed.",
			"type": def.get("type", "side"),
			"act": def.get("act", 0),
		})
	entries.sort_custom(func(a, b):
		if a.act != b.act:
			return int(a.act) < int(b.act)
		if a.type != b.type:
			return a.type == "main"
		return String(a.title) < String(b.title)
	)
	return entries


func mark_journal_read(journal_id: String) -> void:
	if journal_id not in read_journals:
		read_journals.append(journal_id)


func has_read_journal(journal_id: String) -> bool:
	return journal_id in read_journals


func apply_journal(journal_id: String) -> Dictionary:
	var journal: Dictionary = get_journal(journal_id)
	if journal.is_empty():
		return {}
	var first_read := not has_read_journal(journal_id)
	mark_journal_read(journal_id)
	if first_read:
		var quest_id: String = str(journal.get("quest_id", ""))
		if journal.get("start_quest", false) and not quest_id.is_empty():
			start_quest(quest_id)
		if journal.get("complete_objective", false) and not quest_id.is_empty():
			complete_objective(quest_id, str(journal.get("objective_id", "")))
	return journal


func get_npc_dialogue_key(npc_id: String, main_node: Node) -> String:
	var npc: Dictionary = get_npc(npc_id)
	var offers: String = str(npc.get("offers_quest", ""))
	if offers.is_empty():
		return "default"
	if is_complete(offers):
		return "quest_complete"
	if is_active(offers):
		var turn_in: Dictionary = npc.get("turn_in", {})
		if not turn_in.is_empty() and _can_turn_in(main_node, turn_in):
			return "turn_in_ready"
		return "quest_active"
	if offers not in completed_quests and not is_active(offers):
		return "first_meeting"
	return "default"


func get_npc_lines(npc_id: String, main_node: Node) -> PackedStringArray:
	var npc: Dictionary = get_npc(npc_id)
	var dialogue: Dictionary = npc.get("dialogue", {})
	var key: String = get_npc_dialogue_key(npc_id, main_node)
	var lines: Variant = dialogue.get(key, dialogue.get("default", []))
	var out: PackedStringArray = []
	for line in lines:
		out.append(str(line))
	return out


func try_npc_turn_in(npc_id: String, main_node: Node) -> bool:
	var npc: Dictionary = get_npc(npc_id)
	var turn_in: Dictionary = npc.get("turn_in", {})
	if turn_in.is_empty() or not _can_turn_in(main_node, turn_in):
		return false
	var quest_id: String = str(turn_in.get("quest_id", ""))
	var objective_id: String = str(turn_in.get("objective_id", ""))
	_consume_turn_in_equipment(main_node, int(turn_in.get("requires_equipment_count", 1)))
	for reward in turn_in.get("rewards", []):
		var item: Dictionary = reward.duplicate(true)
		_apply_reward_texture(item, main_node)
		main_node.player_items.append(item)
	complete_objective(quest_id, objective_id)
	return true


func _apply_reward_texture(item: Dictionary, main_node: Node) -> void:
	if item.has("texture"):
		return
	for template in main_node.all_items_list:
		if template.get("item_name", "") == item.get("item_name", ""):
			item["texture"] = template.texture
			if not item.has("description"):
				item["description"] = template.get("description", "")
			break


func _can_turn_in(main_node: Node, turn_in: Dictionary) -> bool:
	var quest_id: String = str(turn_in.get("quest_id", ""))
	if not is_active(quest_id):
		return false
	var req_journal: String = str(turn_in.get("requires_journal", ""))
	if not req_journal.is_empty() and not has_read_journal(req_journal):
		return false
	var needed: int = int(turn_in.get("requires_equipment_count", 1))
	return _count_equipment(main_node) >= needed


func _count_equipment(main_node: Node) -> int:
	var count := 0
	for item in main_node.player_inventory:
		if item.get("type", "") in ["weapon", "shield", "head", "body", "accessory"]:
			count += 1
	return count


func _consume_turn_in_equipment(main_node: Node, amount: int) -> void:
	var removed := 0
	var i := 0
	while i < main_node.player_inventory.size() and removed < amount:
		var item: Dictionary = main_node.player_inventory[i]
		if item.get("type", "") in ["weapon", "shield", "head", "body", "accessory"]:
			main_node.player_inventory.remove_at(i)
			removed += 1
		else:
			i += 1
	var player = main_node.current_level_node.get_node_or_null("Player") if main_node.current_level_node else null
	if player:
		player.inventory = main_node.player_inventory


func export_state() -> Dictionary:
	return {
		"active_quests": active_quests.duplicate(true),
		"completed_quests": completed_quests.duplicate(),
		"read_journals": read_journals.duplicate(),
	}


func import_state(state: Dictionary) -> void:
	active_quests = state.get("active_quests", {}).duplicate(true)
	completed_quests = []
	for q in state.get("completed_quests", []):
		completed_quests.append(str(q))
	read_journals = []
	for j in state.get("read_journals", []):
		read_journals.append(str(j))
