extends CanvasLayer

func _on_continue_game_pressed() -> void:
	get_parent().toggle_pause()


func _on_quest_log_pressed() -> void:
	get_parent().toggle_pause()
	get_parent().toggle_quest_log()


func _on_exit_pressed() -> void:
	get_tree().quit()
