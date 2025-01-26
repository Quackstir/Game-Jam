extends Control
@onready var _press_sfx: AudioStreamPlayer2D = $PressSFX
@onready var _hover_sfx: AudioStreamPlayer2D = $HoverSFX

@onready var play: Button = $MarginContainer/VBoxContainer/HBoxContainer/play

func _ready() -> void:
	play.grab_focus()

func _on_play_button_down() -> void:
	await _play_press_sfx()
	get_tree().change_scene_to_file("res://Levels/chris_level.tscn")

func _on_quit_button_down() -> void:
	await _play_press_sfx()
	get_tree().quit()

func _on_play_mouse_entered() -> void:
	_play_on_hover_sfx()

func _on_quit_mouse_entered() -> void:
	_play_on_hover_sfx()


func _play_press_sfx() -> void:
	_press_sfx.play()
	await _press_sfx.finished

func _play_on_hover_sfx() -> void:
	_hover_sfx.play()


func _on_play_focus_entered() -> void:
	_play_on_hover_sfx()


func _on_quit_focus_entered() -> void:
	_play_on_hover_sfx()
