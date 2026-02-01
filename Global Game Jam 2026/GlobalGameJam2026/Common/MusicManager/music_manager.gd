class_name MusicManager
extends Node

const _2026_JAN_GGJ_MENU_AND_WORLD_THEME = preload("uid://bd3pncfpobsxm")

var music_theme:AudioStreamPlayer

func _ready() -> void:
	music_theme = AudioStreamPlayer.new()
	music_theme.stream = _2026_JAN_GGJ_MENU_AND_WORLD_THEME
	music_theme.autoplay = true
	add_child(music_theme)
