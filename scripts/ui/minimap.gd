extends Control

export (NodePath) var map_viewport

func _ready():
	var map = get_node(map_viewport)
	$Viewport.world_2d = map.world_2d
