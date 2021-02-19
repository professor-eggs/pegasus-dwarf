extends Node2D


onready var player : Player = $YSort/Player
onready var walls : TileMap = $YSort/DungeonWall


func _ready() -> void:
	var bounds := walls.get_used_rect()
	player.camera.limit_left = int(walls.map_to_world(bounds.position).x)
	player.camera.limit_top = int(walls.map_to_world(bounds.position).y)
	player.camera.limit_right = int(walls.map_to_world(bounds.size).x)
	player.camera.limit_bottom = int(walls.map_to_world(bounds.size).y)
	
