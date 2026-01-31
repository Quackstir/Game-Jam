extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is PlayerController and Global.game_manager.can_win:
		print("Massive W in the chat")
		Global.scene_manager.change_hud_scene("res://Levels/MarksTest/WinScene.tscn")
