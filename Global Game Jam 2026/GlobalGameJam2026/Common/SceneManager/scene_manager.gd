class_name SceneManager
extends Node

@export var levels: Node2D
@export var huds: Control

var _cur_level_string: String
var _current_level
var _current_hud


func _ready():
	Global.scene_manager = self
	_boot_up_splash_screen()


func change_level_scene(new_level: String, delete: bool = true,
		keep_running: bool = false):
	
	# Deal with the current level
	if _current_level:
		if delete:
			_current_level.queue_free() # Remove level entirely
		elif keep_running:
			_current_level.visible = false # Keep level running in background
		else:
			levels.remove_child(_current_level) # Only keeps level in memory
	
	# switch to the new level
	_cur_level_string = new_level
	var new = load(new_level).instantiate()
	levels.add_child(new)
	_current_level = new


func change_hud_scene(new_hud: String, delete: bool = true,
		keep_running: bool = false):
	
	# Deal with the current hud
	if _current_hud:
		if delete:
			_current_hud.queue_free()
		elif keep_running:
			_current_hud.visible = false # Keep hud running in background
		else:
			huds.remove_child(_current_hud) # Only keeps hud in memory
	
	# switch to the new hud
	var new = load(new_hud).instantiate()
	huds.add_child(new)
	_current_hud = new


func get_current_level() -> Node2D:
	return levels.get_child(0)


func reload_level():
	change_level_scene(_cur_level_string)


func _boot_up_splash_screen():
	var splash = load("res://Levels/MainMenu/main_menu.tscn").instantiate()
	huds.add_child(splash)
	_current_hud = splash
