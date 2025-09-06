extends Node2D


@onready var collision_polygon_2d: CollisionPolygon2D = $Escenario/CollisionPolygon2D
@onready var polygon_2d: Polygon2D = $Escenario/CollisionPolygon2D/Polygon2D

func _ready() -> void:
	polygon_2d.polygon = collision_polygon_2d.polygon
	RenderingServer.set_default_clear_color("black")
