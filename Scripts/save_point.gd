extends StaticBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var player_in_range = false
var save_position
func _input(event):
	if event.is_action_pressed("ui_select") and player_in_range:
		perform_save()

func perform_save():
	var main_node = get_tree().root.get_child(0)
	var save_pos = save_position
	main_node.save_game(save_pos)
	print("Saved at position: ", save_pos)

func _on_save_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		save_position = body.global_position

func _on_save_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
