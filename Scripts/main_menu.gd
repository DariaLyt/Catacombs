extends Control

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_load_game_pressed() -> void:
	#in future will add feature to load some previous game saves
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
