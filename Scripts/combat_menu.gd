extends CanvasLayer

@onready var health_value_label: Label = $HBoxContainer/Stats/HealthBar/VBoxContainer/HBoxContainer/Value

func setup_combat(player_stats: Dictionary, enemy: Node2D):
	health_value_label.text = str(player_stats["health"])
	#$TextureRect.texture = enemy.get_node("AnimatedSprite2D").sprite_frames.get_frame_texture("idle", 0)

func _on_attack_pressed():
	# Simple combat logic
	print("Player attacks!")
	#get_tree().quit()
	# Calculate damage using player_stats["attack"]


func _on_skill_pressed() -> void:
	var main_node = get_tree().root.get_child(0)
	if main_node.has_method("exit_combat"):
		main_node.exit_combat(true)
