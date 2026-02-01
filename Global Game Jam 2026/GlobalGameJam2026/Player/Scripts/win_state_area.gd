extends Area2D

@onready var win_level_sfx: AudioStreamPlayer = $WinLevelSfx

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController and Global.game_manager.can_win:
		print("Massive W in the chat")
		win_level_sfx.play()
		Global.scene_manager.change_hud_scene("res://Levels/MarksTest/WinScene.tscn")
