extends Node2D

signal units_command_issued(target)
signal selection_rect_updated(rect)

export (float) var drag_tolerance

var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var drag_end = Vector2.ZERO
var select_rect = RectangleShape2D.new()

export (NodePath) var camera_path
var camera: Node2D

func _ready():
	camera = get_node(camera_path)

func clear_selection():
	for item in selected:
		item.collider.selected = false

	selected = []

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			clear_selection()

		if event.button_index == BUTTON_LEFT:
			if event.pressed and not dragging:
				dragging = true
				var position = event.position
				drag_start = position
				drag_end = position

			if dragging and not event.pressed:
				dragging = false
				emit_signal("selection_rect_updated", Rect2(Vector2.ZERO, Vector2.ZERO))

				if drag_start == drag_end:
					var target = event.position + camera.position
					for item in selected:
						item.collider.target = target

					emit_signal("units_command_issued", target)
				else:
					clear_selection()

					var start = drag_start + camera.position
					var end = drag_end + camera.position
					select_rect.extents = (end - start) / 2
					var space = get_world_2d().direct_space_state
					var query = Physics2DShapeQueryParameters.new()
					query.set_shape(select_rect)
					query.transform = Transform2D(0, (end + start) / 2)

					selected = space.intersect_shape(query)
					for item in selected:
						item.collider.selected = true

	if event is InputEventMouseMotion and dragging and drag_start.distance_to(event.position) > drag_tolerance:
		drag_end = event.position
		emit_signal("selection_rect_updated", Rect2(drag_start, drag_end - drag_start))
