extends Node2D

export (Color) var command_blip_color
export (float) var command_blip_duration

var units_target: Vector2
var command_blip_timer = 0.0

func _on_units_command_issued(target: Vector2):
	command_blip_timer = 0.0
	units_target = target
	update()

func _process(delta):
	if units_target != Vector2.ZERO:
		command_blip_timer += delta

		if command_blip_timer > command_blip_duration:
			units_target = Vector2.ZERO
			command_blip_timer = 0.0
			update()

func _draw():
	if units_target != Vector2.ZERO:
		draw_circle(units_target, 10, command_blip_color)