extends Control

@onready var label_2: Label = $CanvasLayer/MarginContainer/HBoxContainer/Panel2/VBoxContainer/Label2

func _ready() -> void:
	label_2.text = "Score: " + str(GM.score)
	get_tree().paused = true


func _on_button_pressed() -> void:
	get_tree().paused = false
	GM.can_win = false
	MusicManage.play_music()
	Global.scene_manager.huds.remove_child(self)
	Global.scene_manager.reload_level()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	GM.can_win = false
	MusicManage.play_music()
	Global.scene_manager.get_current_level().queue_free()
	Global.scene_manager.change_hud_scene("res://Levels/MainMenu/main_menu.tscn")
