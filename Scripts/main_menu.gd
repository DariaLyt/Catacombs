extends Control

#func _on_new_game_button_pressed():
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
#
## This runs when 'Load Game' is clicked
#func _on_load_game_button_pressed():
	#print("Loading game...") 
	## Later, will add save/load logic here
#
#func _on_exit_button_pressed():
	#get_tree().quit()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_load_game_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
