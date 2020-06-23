extends AudioStreamPlayer2D
class_name ActorSound


var hit_sound := load("res://assets/sounds/block_fist_3.ogg")
var kill_sound := load("res://assets/sounds/punch_1.ogg")


func play_hit() -> void:
	stream = hit_sound
	play()


func play_kill() -> void:
	stream = kill_sound
	play()
