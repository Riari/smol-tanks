extends Camera2D

export (NodePath) var map_viewport;
export (NodePath) var minimap_viewport_container;
export (float) var move_speed: = 5.0;

var self_viewport_size: Vector2;
var map_viewport_size: Vector2;

func _ready():
	self_viewport_size = self.get_viewport().get_size()
	map_viewport_size = get_node(map_viewport).get_size()

func _process(_delta):
	var map = {
		"camera_up": Vector2(0, -1),
		"camera_left": Vector2(-1, 0),
		"camera_right": Vector2(1, 0),
		"camera_down": Vector2(0, 1)
	}

	var velocity = Vector2.ZERO;
	for action in map:
		if Input.is_action_pressed(action): velocity += map[action];

	self.position += velocity * move_speed;
	self.position.x = clamp(self.position.x, 0, map_viewport_size.x - self_viewport_size.x)
	self.position.y = clamp(self.position.y, 0, map_viewport_size.y - self_viewport_size.y)

	get_node(minimap_viewport_container).material.set_shader_param("camera_pos", self.position)
