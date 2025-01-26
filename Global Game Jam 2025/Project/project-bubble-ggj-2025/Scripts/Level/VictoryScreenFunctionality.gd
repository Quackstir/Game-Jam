extends Control

@onready var press_sfx: AudioStreamPlayer2D = $PressSFX
@onready var hover_sfx: AudioStreamPlayer2D = $HoverSFX
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@onready var play: Button = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/play
@onready var quit: Button = $CanvasLayer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer2/quit

func _ready() -> void:
	play.grab_focus()

func _on_play_button_down() -> void:
	await _play_press_sfx()
	get_tree().change_scene_to_file("res://Levels/test_level.tscn")

func _on_play_mouse_entered() -> void:
	_play_on_hover_sfx()

func _on_quit_button_down() -> void:
	await _play_press_sfx()
	get_tree().quit()

func _on_quit_mouse_entered() -> void:
	_play_on_hover_sfx()


func _on_play_focus_entered() -> void:
	_play_on_hover_sfx()


func _on_quit_focus_entered() -> void:
	_play_on_hover_sfx()
	
func _play_press_sfx() -> void:
	press_sfx.play()
	await press_sfx.finished

func _play_on_hover_sfx() -> void:
	hover_sfx.play()
