@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("ColorMatrixCanvas", "CanvasGroup", preload("nodes/ColorMatrixCanvas.gd"), preload("icons/color_matrix_icon.svg"))

func _exit_tree() -> void:
	remove_custom_type("ColorMatrixCanvas")
