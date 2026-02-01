extends Area2D

@export var end_game:bool = true
@onready var win_level_sfx: AudioStreamPlayer = $WinLevelSfx

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController and Global.game_manager.can_win:
		print("Massive W in the chat")
		win_level_sfx.play()
		if end_game:
			Global.scene_manager.change_hud_scene("res://Levels/MarksTest/WinScene.tscn")
		else:
			Global.scene_manager.change_level_scene("res://Levels/ChrisTest/ChrisTestLevel.tscn")
