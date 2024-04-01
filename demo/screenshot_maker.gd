extends Node

@export var generate_screenshots := false

var markdown := []

func _ready() -> void:
	if generate_screenshots:
		_generate_screenshots()

func _generate_screenshots():
	markdown = []
	
	$CanvasGroup.matrix = ColorMatrix.new()
	
	var cm: ColorMatrix = $CanvasGroup.matrix
	cm.duotone_enabled = false
	cm.simulate_color_blindness = ColorMatrix.ColorBlindness.NONE
	
	# Advanced tints.
	for i in len(ColorMatrix.BuiltIn):
		var id: String = ColorMatrix.BuiltIn.keys()[i]
		cm.built_in = i
		$Label.text = id.capitalize()
		await take_screenshot(id.capitalize(), "adv_" + id.to_lower())
	
	# Duotone.
	cm.built_in = ColorMatrix.BuiltIn.NONE
	cm.duotone_enabled = true
	cm.saturation = 0.0
	$Label.text = "Duotone"
	await take_screenshot("Duotone", "Duotone")
	
	cm.duotone_enabled = false
	cm.saturation = 1.0
	
	# Color Blindness
	for i in range(1, len(ColorMatrix.ColorBlindness)):
		var id: String = ColorMatrix.ColorBlindness.keys()[i]
		cm.simulate_color_blindness = i
		$Label.text = "Color Blind: " + id.capitalize()
		await take_screenshot(id.capitalize(), "cb_" + id.to_lower())
	
	var rows := 3
	var final := []
	var top := []
	var bot := []
	for j in rows:
		top.append(" ")
		bot.append("-")
	final.append("|" + "|".join(top) + "|")
	final.append("|" + "|".join(bot) + "|")
	for i in range(0, len(markdown), rows):
		var row := []
		for j in rows:
			if len(markdown):
				row.append(markdown.pop_front())
			else:
				row.append("")
		final.append("|" + "|".join(row) + "|")
	print("\n".join(final))

func take_screenshot(md_name: String, id: String):
	await RenderingServer.frame_post_draw
	var screenshot := get_viewport().get_texture().get_image()
	screenshot.shrink_x2()
	screenshot.save_webp("res://demo/screenshots/%s.webp" % [id], true, 0.75)
	
	markdown.append("![](./demo/screenshots/%s.webp)" % [id])
