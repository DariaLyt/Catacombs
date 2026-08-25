extends StaticBody2D

@export var bookshelf_id: String = ""
@export var mode: String = "loot"
@export var journal_id: String = ""

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var player_in_range := false
var is_looted := false


func _ready() -> void:
	call_deferred("_apply_looted_state")

func _apply_looted_state() -> void:
	var main_node = get_tree().get_first_node_in_group("game_main")
	if main_node == null:
		return
	if bookshelf_id in main_node.looted_containers:
		set_as_looted()


func _input(event: InputEvent) -> void:
	if _main_blocked():
		return
	if not (event.is_action_pressed("ui_select") and player_in_range):
		return
	if mode == "journal":
		_read_journal()
	elif not is_looted:
		loot_bookshelf()


func _read_journal() -> void:
	if journal_id.is_empty():
		return
	var main_node = get_tree().get_first_node_in_group("game_main")
	if main_node.has_method("show_journal"):
		main_node.show_journal(journal_id)
	if not is_looted and not bookshelf_id.is_empty():
		is_looted = true
		if bookshelf_id not in main_node.looted_containers:
			main_node.looted_containers.append(bookshelf_id)
		set_as_looted()


func loot_bookshelf() -> void:
	is_looted = true
	var main_node = get_tree().get_first_node_in_group("game_main")
	var item_count = randi() % 3
	for i in range(item_count):
		main_node.player_items.append(main_node.books_list.pick_random())
	main_node.looted_containers.append(bookshelf_id)
	set_as_looted()


func set_as_looted() -> void:
	is_looted = true
	animated_sprite_2d.modulate = Color(0.5, 0.5, 0.5)


func _on_loot_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_loot_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false


func _main_blocked() -> bool:
	var main_node = get_tree().get_first_node_in_group("game_main")
	if get_tree().paused:
		return true
	return main_node.get("_dialogue_open") == true
