@tool
@icon("res://addons/color_matrix/matrix.svg")
extends Resource
class_name Matrix
# TODO:

## Multiplied against every pixel in shader.
@export var matrix := Projection.IDENTITY:
	set(m):
		matrix = m
		emit_changed()

## Added to pixels in shader.
@export var offset := Vector4.ZERO:
	set(o):
		offset = o
		emit_changed()

func _init(
	x := Vector4(1.0, 0.0, 0.0, 0.0),
	y := Vector4(0.0, 1.0, 0.0, 0.0),
	z := Vector4(0.0, 0.0, 1.0, 0.0),
	w := Vector4(0.0, 0.0, 0.0, 1.0),
	offset := Vector4.ZERO):
		self.matrix = Projection(x, y, z, w)
		self.offset = offset

func multiply(with: Variant):
	if with is Projection:
		matrix *= with
	elif with is Matrix:
		matrix *= with.matrix

func clamp_values():
	for i in 4:
		for j in 4:
			matrix[i][j] = clampf(matrix[i][j], 0.0, 1.0)
