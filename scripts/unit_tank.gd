extends KinematicBody2D

export var rotation_correction = -90.0
export var speed = 100  # Movement speed.
var av = Vector2.ZERO  # Avoidance vector.
var avoid_weight = 0.1  # How strongly to avoid other units.
var target_radius = 30  # Stop when this close to target.
var target = null setget set_target  # Set this to move.
var selected = false setget set_selected  # Is this unit selected?
var velocity = Vector2.ZERO

export (NodePath) var tilemap_path
var tilemap: TileMap

func _ready():
	# Make sure the material is unique to this unit.
	$Sprite.material = $Sprite.material.duplicate()
	tilemap = get_node(tilemap_path)
	
func _physics_process(delta):
	velocity = Vector2.ZERO
	if target:
		# If there's a target, move toward it.
		velocity = position.direction_to(target)
		if position.distance_to(target) < target_radius:
			target = null
	# Find avoidance vector and add to velocity.
	av = avoid()
	velocity = (velocity + av * avoid_weight).normalized()
	if velocity.length() > 0:
		# Rotate body to point in movement direction.
		rotation = velocity.angle()
		rotation_degrees += rotation_correction

	var actual_speed = speed
	var tile = tilemap.get_cellv(position)
	if (tile != TileMap.INVALID_CELL):
		var nav_poly = tilemap.tile_get_navigation_polygon(tile)
		if position in nav_poly:
			actual_speed /= 2.0

	var _collision = move_and_collide(velocity * actual_speed * delta)
	update()

func set_selected(value):
	selected = value
	$Sprite.material.set_shader_param("on", selected)

func set_target(value):
	target = value

func avoid():
	# Calculates avoidance vector based on nearby units.
	var result = Vector2.ZERO
	var neighbors = $Detect.get_overlapping_bodies()
	if !neighbors:
		return result
	for n in neighbors:
		result += n.position.direction_to(position)
	result /= neighbors.size()
	return result.normalized()
