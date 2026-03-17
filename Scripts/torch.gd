extends Area2D
@onready var fire_sound: AudioStreamPlayer2D = $FireSound

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		fire_sound.play()



func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		fire_sound.stop()
