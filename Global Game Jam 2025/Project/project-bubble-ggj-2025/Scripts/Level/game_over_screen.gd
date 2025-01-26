extends Control

@onready var _press_sfx: AudioStreamPlayer2D = $PressSFX
@onready var _hover_sfx: AudioStreamPlayer2D = $HoverSFX

func _on_retry_button_button_down() -> void:
	await _play_press_sfx()
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")
	LevelTransition.fade_from_black()

func _on_retry_button_mouse_entered() -> void:
	_play_on_hover_sfx()

func _on_main_menu_button_button_down() -> void:
	await _play_press_sfx()
	get_tree().paused = true
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")
	LevelTransition.fade_from_black()


func _on_main_menu_button_mouse_entered() -> void:
	_play_on_hover_sfx()

func _play_press_sfx() -> void:
	_press_sfx.play()
	await _press_sfx.finished

func _play_on_hover_sfx() -> void:
	_hover_sfx.play()
