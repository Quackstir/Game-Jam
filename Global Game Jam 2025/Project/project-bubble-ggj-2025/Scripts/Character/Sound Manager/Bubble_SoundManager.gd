extends Node

@export var Player:bubble_character

@export var JumpSFX:Array[AudioStreamMP3] 
@onready var asp_jump_sfx: AudioStreamPlayer = %ASP_JumpSFX

@export var JumpRestoreSFX:AudioStreamMP3
@onready var asp_jump_restore_sfx: AudioStreamPlayer = %ASP_JumpRestoreSFX

@export var SizeGrowSFX:AudioStreamMP3
@onready var asp_grow: AudioStreamPlayer = %ASP_Grow

func _ready() -> void:
	Player.player_jumped.connect(jumpPlay)
	Player.jump_restored.connect(jumpRestorePlay)
	Player.player_grew.connect(SizeGrowPlay)

func jumpPlay(amount:int):
	asp_jump_sfx.stream = JumpSFX[randi_range(0,JumpSFX.size() - 1)]
	asp_jump_sfx.pitch_scale = randf_range(0.8,1.2)
	asp_jump_sfx.play()

func jumpRestorePlay(amount:int):
	asp_jump_restore_sfx.stream = JumpRestoreSFX
	asp_jump_restore_sfx.pitch_scale = randf_range(0.8,1.2)
	asp_jump_restore_sfx.play()
	
func SizeGrowPlay(amount:int):
	asp_grow.stream = SizeGrowSFX
	asp_grow.pitch_scale = randf_range(0.8,1.2)
	asp_grow.play()
