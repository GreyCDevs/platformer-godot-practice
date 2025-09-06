extends Node2D

@export var next_level: PackedScene

@onready var level_completed: ColorRect = $CanvasLayer/LevelCompleted
@onready var start_in: ColorRect = %StartIn
@onready var start_in_label: Label = %StartInLabel
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer_label: Label = %TimerLabel

var time_passed: int = 0

func _ready() -> void:
	Events.level_completed.connect(show_level_completed)
	get_tree().paused = true
	animation_player.play("countdown")
	await get_tree().create_timer(3.0).timeout
	start_in_label.hide()
	get_tree().paused = false
	animation_player.play("hide_start_label")
	if animation_player.animation_finished:
		start_in.hide()
	
	
func show_level_completed() -> void:
	level_completed.show()
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	if not next_level is PackedScene: 
		get_tree().change_scene_to_file("res://scenes/ui/menu/start_menu.tscn")
		return
	await LevelTransition.fade_to_black()
	get_tree().paused = false
	get_tree().change_scene_to_packed(next_level)
	LevelTransition.fade_from_black()


func _on_timer_timeout() -> void:
	time_passed += 1
	var minutes = int(time_passed / 60)
	var seconds = time_passed - minutes * 60
	timer_label.text = "Time: %02d:%02d" % [minutes, seconds]
