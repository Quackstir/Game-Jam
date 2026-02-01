class_name MusicManager
extends Node

const _2026_JAN_GGJ_MENU_AND_WORLD_THEME = preload("uid://bd3pncfpobsxm")
const _2026_JAN_GGJ_BATTLE_THEME = preload("uid://co6xam1i8snx1")

var music_theme:AudioStreamPlayer
var battle_theme:AudioStreamPlayer

func _ready() -> void:
	music_theme = AudioStreamPlayer.new()
	music_theme.stream = _2026_JAN_GGJ_MENU_AND_WORLD_THEME
	music_theme.autoplay = true
	music_theme.volume_db = -8
	add_child(music_theme)
	
	battle_theme = AudioStreamPlayer.new()
	battle_theme.stream = _2026_JAN_GGJ_BATTLE_THEME
	#battle_theme.autoplay = true
	battle_theme.volume_db = -8
	add_child(battle_theme)


func play_battle_theme() -> void:
	battle_theme.play()
	music_theme.stream_paused = true


func stop_battle_theme() -> void:
	battle_theme.stop()
	music_theme.stream_paused = false
