extends Node2D


@onready var collision_polygon_2d: CollisionPolygon2D = $Escenario/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Escenario/CollisionPolygon2D/Polygon2D
@onready var level_completed: ColorRect = $CanvasLayer/LevelCompleted

func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	RenderingServer.set_default_clear_color("black")
	Events.level_completed.connect(show_level_completed)
	
func show_level_completed() -> void:
	level_completed.show()
	get_tree().paused = true
