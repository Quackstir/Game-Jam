class_name SceneManager
extends Node

@export var level: Node2D
@export var hud: Control

var current_level
var current_hud

func _ready():
	Global.scene_manager = self
	_boot_up_splash_screen()

func change_level_scene(new_level: String, delete: bool = true,
		keep_running: bool = false):
	
	# Deal with the current level
	if current_level:
		if delete:
			current_level.queue_free() # Remove level entirely
		elif keep_running:
			current_level.visible = false # Keep level running in background
		else:
			level.remove_child(current_level) # Only keeps level in memory
	
	# switch to the new level
	var new = load(new_level).instantiate()
	level.add_child(new)
	current_level = new

func change_hud_scene(new_hud: String, delete: bool = true,
		keep_running: bool = false):
	
	# Deal with the current level
	if current_hud:
		if delete:
			current_hud.queue_free()
		elif keep_running:
			current_hud.visible = false # Keep level running in background
		else:
			hud.remove_child(current_hud) # Only keeps level in memory
	
	# switch to the new level
	var new = load(new_hud).instantiate()
	hud.add_child(new)
	current_hud = new

func _boot_up_splash_screen():
	var splash = load("res://Levels/CarlosTest/CarlosTestMenu.tscn").instantiate()
	level.add_child(splash)
	current_level = splash
