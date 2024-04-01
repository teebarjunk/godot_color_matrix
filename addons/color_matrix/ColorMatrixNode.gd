@tool
@icon("res://addons/color_matrix/color_matrix_icon.svg")
extends Node
class_name ColorMatrixNode

## An operation to apply to all the pixels.
@export var matrix: ColorMatrix:
	set(m):
		matrix = m
		if matrix:
			if not matrix.changed.is_connected(matrix.apply):
				matrix.changed.connect(matrix.apply.bind(self))

## For blending with matrix.
@export var matrix2: ColorMatrix:
	set(m):
		matrix2 = m
		if matrix2:
			if not matrix2.changed.is_connected(matrix.apply):
				matrix2.changed.connect(matrix2.apply.bind(self))

## Amount to blend between matrix and matrix2.
@export_range(0.0, 1.0) var blend := 0.0:
	set(t):
		blend = t
		if not matrix or not matrix2:
			push_error("Blend requires both matrices to be setup.")
			return
		matrix.apply_lerp(self, matrix2, t)

## Duration of blending animation.
@export var blend_duration := 1.0
@export var blend_trans := Tween.TRANS_LINEAR
@export var blend_ease := Tween.EASE_OUT

## Test animation.
## Call [code]play_colormatrix_tween()[/code] in game.
@export var blend_play := false:
	set(b):
		blend_play = b
		if blend_play:
			play_colormatrix_tween()

@export var blend_play_backwards := false:
	set(b):
		blend_play_backwards = b
		if blend_play_backwards:
			play_colormatrix_tween(true)

var tween: Tween

func play_colormatrix_tween(backwards := false):
	if tween:
		tween.kill()
	tween = create_tween()
	blend = 1.0 if backwards else 0.0
	tween.tween_property(self, "blend", 0.0 if backwards else 1.0, blend_duration)\
		.set_trans(blend_trans)\
		.set_ease(blend_ease)
	tween.tween_callback(func():
		if backwards:
			blend_play_backwards = false
		else:
			blend_play = false
	)
