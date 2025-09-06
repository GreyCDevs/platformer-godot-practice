extends Node2D

@export var next_level: PackedScene

@onready var level_completed: ColorRect = $CanvasLayer/LevelCompleted

func _ready() -> void:
	RenderingServer.set_default_clear_color("black")
	Events.level_completed.connect(show_level_completed)
	
func show_level_completed() -> void:
	if next_level is PackedScene: 
		get_tree().change_scene_to_packed(next_level)
		return
	get_tree().paused = true
	level_completed.show()
