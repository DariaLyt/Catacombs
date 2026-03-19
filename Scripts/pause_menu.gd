extends CanvasLayer

func _on_continue_game_pressed() -> void:
	get_parent().toggle_pause()
	#resume_requested.emit("Hello world")


func _on_exit_pressed() -> void:
	get_tree().quit()
