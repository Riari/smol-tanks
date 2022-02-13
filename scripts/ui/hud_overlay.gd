extends Control

export (Color) var unit_selection_border_color
export (Color) var unit_selection_fill_color

var unit_selection_rect: Rect2

func _on_unit_selection_rect_updated(rect: Rect2):
	unit_selection_rect = rect
	update()

func _draw():
	draw_rect(unit_selection_rect, unit_selection_fill_color)
	draw_rect(unit_selection_rect, unit_selection_border_color, false)
