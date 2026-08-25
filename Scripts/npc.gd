extends StaticBody2D

@export var npc_id: String = "surface_merchant"
@export var display_name: String = ""

@onready var name_label: Label = $NameLabel

var player_in_range := false
var _talking := false


func _ready() -> void:
	if display_name.is_empty():
		var data: Dictionary = QuestManager.get_npc(npc_id)
		display_name = str(data.get("display_name", npc_id))
	name_label.text = display_name


func _input(event: InputEvent) -> void:
	if _talking or not player_in_range or _main_blocked():
		return
	if event.is_action_pressed("ui_select"):
		_talk_to_player()


func _main_blocked() -> bool:
	if get_tree().paused:
		return true
	var main_node = get_tree().get_first_node_in_group("game_main")
	return main_node.get("_dialogue_open") == true


func _talk_to_player() -> void:
	var main_node = get_tree().get_first_node_in_group("game_main")
	if not main_node.has_method("begin_npc_dialogue"):
		return
	_talking = true
	main_node.begin_npc_dialogue(npc_id, func(): _talking = false)


func _on_interact_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true


func _on_interact_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
