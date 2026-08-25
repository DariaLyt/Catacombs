extends CanvasLayer

@onready var list: ItemList = $Panel/Margin/VBox/QuestList
@onready var detail: Label = $Panel/Margin/VBox/DetailLabel


func _ready() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS


func refresh() -> void:
	list.clear()
	var entries := QuestManager.get_quest_log_entries()
	if entries.is_empty():
		list.add_item("(No quests yet)")
		detail.text = "Explore the catacombs. Journals and NPCs will set your path."
		return
	for entry in entries:
		var prefix := "[Done] " if entry.status == "complete" else "[Active] "
		list.add_item(prefix + entry.title)
		list.set_item_metadata(list.item_count - 1, entry)
	if list.item_count > 0:
		list.select(0)
		_on_quest_list_item_selected(0)


func _on_quest_list_item_selected(index: int) -> void:
	var entry = list.get_item_metadata(index)
	if entry == null:
		return
	var type_label := "Main" if entry.type == "main" else "Side"
	detail.text = "%s quest — Act %s\n\n%s" % [type_label, entry.act, entry.objective]


func _on_close_pressed() -> void:
	hide()
	get_tree().paused = false


func open() -> void:
	refresh()
	show()
