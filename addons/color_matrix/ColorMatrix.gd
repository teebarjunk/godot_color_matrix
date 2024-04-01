@icon("res://addons/color_matrix/color_matrix_icon.svg")
@tool
extends Resource
class_name ColorMatrix
# Misc Credits:
# https://github.com/pixijs/pixijs/blob/723fc51d85b7cda0427ca1f87d92cce96567f5f7/src/filters/defaults/color-matrix/ColorMatrixFilter.ts#L18
# https://github.com/renpy/renpy/blob/2d2867ef2121e29f884c69a7e554bee7cf823779/renpy/display/im.py#L1361
# https://github.com/renpy/renpy/blob/2d2867ef2121e29f884c69a7e554bee7cf823779/renpy/common/00matrixcolor.rpy#L151
enum AdvancedTints {
	NONE,
	SEPIA,
	BGR,
	VINTAGE,
	POLAROID,
	TECHNICOLOR,
	KODACHROME,
	BROWNI,
	LSD,
	PREDATOR,
	DESATURATE_LUMINANCE,
	NIGHT_VISION
}

const THERMAL := Projection(
	Vector4(2.94067, 0, 0, 0.0197754),
	Vector4(1, 0, 0, 0),
	Vector4(-0.898438, 0, 0, 0.632812),
	Vector4(0, 0, 0, 1))

const IDENTITY := Projection(
	Vector4(1., 0., 0., 0),
	Vector4(0., 1., 0., 0.),
	Vector4(0., 0., 1., 0.),
	Vector4(0., 0., 0., 1.))

const DESATURATE_LUMINANCE := Projection(
	Vector4(0.2764723, 0.9297080, 0.0938197, 0), 
	Vector4(0.2764723, 0.9297080, 0.0938197, 0), 
	Vector4(0.2764723, 0.9297080, 0.0938197, 0), 
	Vector4(0, 0, 0, 1))
const DESATURATE_LUMINANCE_OFFSET := Vector4(-37.1, -37.1, -37.1, 0.0)

const NIGHT_VISION := Projection(
	Vector4(1, 0, 0, 0),
	Vector4(1, 0, 0, 0),
	Vector4(1, 0, 0, 0),
	Vector4(0, 0, 0, 1))
#const BLACK_WHITE := Projection(
	#0.3, 0.6, 0.1, 0, 0,
	#0.3, 0.6, 0.1, 0, 0,
	#0.3, 0.6, 0.1, 0, 0,
	#0, 0, 0, 1, 0 ];
#)

const SEPIA := Projection(
	Vector4(0.393, 0.7689999, 0.18899999, 0),
	Vector4(0.349, 0.6859999, 0.16799999, 0),
	Vector4(0.272, 0.5339999, 0.13099999, 0),
	Vector4(0, 0, 0, 1))

const POLAROID := Projection(
	Vector4(1.438, -0.062, -0.062, 0),
	Vector4(-0.122, 1.378, -0.122, 0),
	Vector4(-0.016, -0.016, 1.483, 0),
	Vector4(0, 0, 0, 1))

const LSD := Projection(
	Vector4(2, -0.4, 0.5, 0),
	Vector4(-0.5, 2, -0.4, 0),
	Vector4(-0.4, -0.5, 3, 0),
	Vector4(0, 0, 0, 1))

const BGR := Projection(
	Vector4(0, 0, 1, 0),
	Vector4(0, 1, 0, 0),
	Vector4(1, 0, 0, 0),
	Vector4(0, 0, 0, 1))

const TECHNICOLOR := Projection(
	Vector4(1.9125277891456083, -0.8545344976951645, -0.09155508482755585, 0), 
	Vector4(-0.3087833385928097, 1.7658908555458428, -0.10601743074722245, 0), 
	Vector4(-0.231103377548616, -0.7501899197440212, 1.847597816108189, 0), 
	Vector4(0, 0, 0, 1))
const TECHNICOLOR_OFFSET := Vector4(11.793603434377337,-70.35205161461398,30.950940869491138, 0.0)

const KODACHROME := Projection(
	Vector4(1.1285582396593525, -0.3967382283601348, -0.03992559172921793, 0),
	Vector4(-0.16404339962244616, 1.0835251566291304, -0.05498805115633132, 0),
	Vector4(-0.16786010706155763, -0.5603416277695248, 1.6014850761964943, 0),
	Vector4(0, 0, 0, 1))
const KODACHROME_OFFSET := Vector4(63.72958762196502, 24.732407896706203, 35.62982807460946, 0)

const BROWNI := Projection(
	Vector4(0.5997023498159715, 0.34553243048391263, -0.2708298674538042, 0),
	Vector4(-0.037703249837783157, 0.8609577587992641, 0.15059552388459913, 0),
	Vector4(0.24113635128153335, -0.07441037908422492, 0.44972182064877153, 0),
	Vector4(0, 0, 0, 1))
const BROWNI_OFFSET := Vector4(47.43192855600873, -36.96841498319127, -7.562075277591283, 0.0)

const VINTAGE := Projection(
	Vector4(0.6279345635605994, 0.3202183420819367, -0.03965408211312453, 0),
	Vector4(0.02578397704808868, 0.6441188644374771, 0.03259127616149294, 0),
	Vector4(0.0466055556782719, -0.0851232987247891, 0.5241648018700465, 0),
	Vector4(0, 0, 0, 1))
const VINTAGE_OFFSET := Vector4(9.651285835294123, 7.462829176470591, 5.159190588235296, 0.0)

const PREDATOR := Projection(
	Vector4(11.224130630493164, -4.794486999511719, -2.8746118545532227, 0.0),
	Vector4(-3.6330697536468506, 9.193157196044922, -2.951810836791992, 0.0),
	Vector4(-3.2184197902679443, -4.2375030517578125, 7.476448059082031, 0.0),
	Vector4(0, 0, 0, 1))
const PREDATOR_OFFSET := Vector4(0.40342438220977783, -1.316135048866272, 0.8044459223747253, 0.0)

#region Color Blindness.
enum ColorBlindness {
	## Normal. No matrix used.
	NONE,
	## Green-Blind
	DEUTERANOPIA,
	## Red-Blind
	PROTANOPIA,
	## Green-Weak
	DEUTERANOMALY,
	## Red-Weak
	PROTANOMALY,
	## Blue-Blind
	TRITANOPIA,
	## Blue-Weak
	TRITANOMALY,
	## Monochromacy
	ACHROMATOPSIA,
	## Blue Cone Monochromacy
	ACHROMATOMALY
}
const CLRBLND_DEUTERANOPIA := Projection( 
	Vector4(0.625, 0.375, 0.000, 0.0),
	Vector4(0.700, 0.300, 0.000, 0.0),
	Vector4(0.000, 0.300, 0.700, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_PROTANOPIA := Projection(   
	Vector4(0.567, 0.433, 0.000, 0.0),
	Vector4(0.558, 0.442, 0.000, 0.0),
	Vector4(0.000, 0.242, 0.758, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_DEUTERANOMALY := Projection(
	Vector4(0.800, 0.200, 0.000, 0.0),
	Vector4(0.258, 0.742, 0.000, 0.0),
	Vector4(0.000, 0.142, 0.858, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_PROTANOMALY := Projection(  
	Vector4(0.817, 0.183, 0.000, 0.0),
	Vector4(0.333, 0.667, 0.000, 0.0),
	Vector4(0.000, 0.125, 0.875, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_TRITANOPIA := Projection(   
	Vector4(0.950, 0.050, 0.000, 0.0),
	Vector4(0.000, 0.433, 0.567, 0.0),
	Vector4(0.000, 0.475, 0.525, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_TRITANOMALY := Projection(  
	Vector4(0.967, 0.033, 0.00, 0.0),
	Vector4(0.00, 0.733, 0.267, 0.0),
	Vector4(0.00, 0.183, 0.817, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_ACHROMATOPSIA := Projection(
	Vector4(0.299, 0.587, 0.114, 0.0),
	Vector4(0.299, 0.587, 0.114, 0.0),
	Vector4(0.299, 0.587, 0.114, 0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
const CLRBLND_ACHROMATOMALY := Projection(
	Vector4(0.618,0.320,0.062,0.0),
	Vector4(0.163,0.775,0.062,0.0),
	Vector4(0.163,0.320,0.516,0.0),
	Vector4(0.0, 0.0, 0.0, 1.0))
#endregion

@export var enabled := true:
	set(e):
		enabled = e
		emit_changed()

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY)
var colormatrix := Projection.IDENTITY

@export_custom(PROPERTY_HINT_NONE, "", PROPERTY_USAGE_READ_ONLY)
var colormatrix_offset := Vector4.ZERO

## Prebuilt color effects to build off of.
@export var advanced_tint := AdvancedTints.NONE:
	set(a):
		advanced_tint = a
		_update()

## Tweak the intensity.
## Going over 1.0 might look bad.
@export_range(-1.0, 2.0) var advanced_tint_amount := 1.0:
	set(a):
		advanced_tint_amount = a
		_update()

## Less than 1.0 desatures the colors to black and white.
## More than 1.0 will boost the colors.
@export_range(0.0, 2.0) var saturation := 1.0:
	set(s):
		saturation = s
		_update()

@export_range(-1.0, 1.0) var brightness := 0.0:
	set(b):
		brightness = b
		_update()

## Enhance the contrast.
@export_range(0.0, 2.0) var contrast := 1.0:
	set(c):
		contrast = c
		_update()

@export_range(0.0, 2.0) var contrast2 := 1.0:
	set(c):
		contrast2 = c
		_update()

## Less than 0.0 is warm/red.
## More than 0.0 is cold/blue.
@export_range(-2.0, 2.0) var temperature := 0.0:
	set(t):
		temperature = t
		_update()

## Shift the hue of colors.
@export_range(-180.0, 180.0) var hue_shift := 0.0:
	set(h):
		hue_shift = h
		_update()

## Tint colors.
@export var tint := Color.WHITE:
	set(t):
		tint = t
		_update()

## Modify alpha.
@export_range(0.0, 1.0) var opacity := 1.0:
	set(o):
		opacity = o
		_update()

@export_range(0.0, 1.0) var invert := 0.0:
	set(i):
		invert = i
		_update()

@export_range(0.0, 2.0) var gamma := 1.0:
	set(g):
		gamma = g
		_update()

## Mostly useless?
@export var clamp_matrix := false:
	set(c):
		clamp_matrix = c
		_update()

@export_group("Duotone", "duotone_")
## Blends a grayscale image between two tones.
@export var duotone_enabled := false:
	set(de):
		duotone_enabled = de
		_update()

@export_range(0.0, 1.0) var duotone_amount := 1.0:
	set(da):
		duotone_amount = da
		_update()

@export var duotone_light := Color.YELLOW:
	set(tl):
		duotone_light = tl
		_update()

@export var duotone_dark := Color.BLUE:
	set(td):
		duotone_dark = td
		_update()

## Many people are color blind, so it may be useful to test that things are working visually.
@export var simulate_color_blindness := ColorBlindness.NONE:
	set(scb):
		simulate_color_blindness = scb
		_update()

@export_group("Initial", "initial_")
## Advanced use.
@export var initial_matrix := Projection.IDENTITY:
	set(i):
		initial_matrix = i
		_update()

## Advanced use.
@export var initial_offset := Vector4.ZERO:
	set(i):
		initial_offset = i
		_update()

func _init(mat := IDENTITY) -> void:
	colormatrix = mat

func _update():
	colormatrix = initial_matrix
	colormatrix_offset = initial_offset * 256.0
	
	if gamma != 1.0:
		colormatrix *= mat_gamma(gamma)
	
	if saturation != 1.0:
		colormatrix *= mat_saturation(saturation)
	
	if hue_shift != 0.0:
		colormatrix *= mat_hue(hue_shift)
		
	if contrast != 1.:
		colormatrix *= mat_contrast(contrast)
	
	if contrast2 != 1.:
		var amount := 1.0 - contrast2
		var scale_factor := contrast2
		if contrast2 < 1.0:
			amount = contrast2
			scale_factor = 1.0 - contrast2
		colormatrix *= Projection(
			Vector4(scale_factor, 0.0, 0.0, 0.0),
			Vector4(0.0, scale_factor, 0.0, 0.0),
			Vector4(0.0, 0.0, scale_factor, 0.0),
			Vector4(0.0, 0.0, 0.0, 1.0))
		# Offset vector for decreasing darks
		colormatrix_offset += Vector4(amount, amount, amount, 0.0) * 256.0
	
	if temperature != 0.:
		colormatrix *= mat_temp(temperature)
	
	if invert != 0.:
		colormatrix *= mat_invert(invert)
	
	if tint != Color.WHITE:
		colormatrix *= mat_tint(tint)
	
	if brightness != 0.0:
		colormatrix *= mat_brightness(brightness)
	
	if opacity != 1.0:
		colormatrix *= mat_opacity(opacity)
	
	if advanced_tint != AdvancedTints.NONE:
		match advanced_tint:
			AdvancedTints.SEPIA: _adv_lerp(SEPIA)
			AdvancedTints.POLAROID: _adv_lerp(POLAROID)
			AdvancedTints.BGR: _adv_lerp(BGR)
			AdvancedTints.LSD: _adv_lerp(LSD)
			AdvancedTints.VINTAGE: _adv_lerp(VINTAGE)
			AdvancedTints.NIGHT_VISION: _adv_lerp(NIGHT_VISION)
			AdvancedTints.TECHNICOLOR: _adv_lerp2(TECHNICOLOR, TECHNICOLOR_OFFSET)
			AdvancedTints.KODACHROME: _adv_lerp2(KODACHROME, KODACHROME_OFFSET)
			AdvancedTints.BROWNI: _adv_lerp2(BROWNI, BROWNI_OFFSET)
			AdvancedTints.DESATURATE_LUMINANCE: _adv_lerp2(DESATURATE_LUMINANCE, DESATURATE_LUMINANCE_OFFSET)
			AdvancedTints.PREDATOR: _adv_lerp2(PREDATOR, PREDATOR_OFFSET)
	
	if duotone_enabled:
		if duotone_amount == 1.0:
			colormatrix *= mat_duotone(duotone_dark, duotone_light)
		elif duotone_amount > 0.0:
			colormatrix *= mat_lerp(IDENTITY, mat_duotone(duotone_dark, duotone_light), duotone_amount)
	
	if clamp_matrix:
		for i in 4:
			for j in 4:
				colormatrix[i][j] = clampf(colormatrix[i][j], 0.0, 1.0)
	
	if simulate_color_blindness != ColorBlindness.NONE:
		match simulate_color_blindness:
			ColorBlindness.DEUTERANOPIA: colormatrix *= CLRBLND_DEUTERANOPIA 
			ColorBlindness.PROTANOPIA: colormatrix *= CLRBLND_PROTANOPIA   
			ColorBlindness.DEUTERANOMALY: colormatrix *= CLRBLND_DEUTERANOMALY
			ColorBlindness.PROTANOMALY: colormatrix *= CLRBLND_PROTANOMALY  
			ColorBlindness.TRITANOPIA: colormatrix *= CLRBLND_TRITANOPIA   
			ColorBlindness.TRITANOMALY: colormatrix *= CLRBLND_TRITANOMALY  
			ColorBlindness.ACHROMATOPSIA: colormatrix *= CLRBLND_ACHROMATOPSIA
			ColorBlindness.ACHROMATOMALY: colormatrix *= CLRBLND_ACHROMATOMALY
	
	# Convert from 0-255 space to 0.0-1.0 space.
	colormatrix_offset /= 256.0
	emit_changed()

static func _get_tool_buttons():
	return ["print_matrix"]

func print_matrix():
	print(var_to_str({"matrix": colormatrix, "offset": colormatrix_offset}))

func _adv_lerp(mat: Projection):
	if advanced_tint_amount == 1.0:
		colormatrix *= mat
	elif advanced_tint_amount > 0.0:
		colormatrix *= mat_lerp(IDENTITY, mat, advanced_tint_amount)

func _adv_lerp2(mat: Projection, off: Vector4):
	if advanced_tint_amount == 1.0:
		colormatrix *= mat
		colormatrix_offset += off
	elif advanced_tint_amount > 0.0:
		colormatrix *= mat_lerp(IDENTITY, mat, advanced_tint_amount)
		colormatrix_offset += colormatrix_offset.lerp(off, advanced_tint_amount)

func apply(node: Node, param_mat := "colormatrix", param_off := "colormatrix_offset"):
	mat_apply(node, colormatrix, colormatrix_offset, param_mat, param_off)

## Lerp a matrix and it's offset.
func apply_lerp(node: Node, other: ColorMatrix, amount: float, param_mat := "colormatrix", param_off := "colormatrix_offset"):
	var off := colormatrix_offset.lerp(other.colormatrix_offset, amount)
	var lmat := mat_lerp(colormatrix, other.colormatrix, amount)
	mat_apply(node, lmat, off, param_mat, param_off)

static func mat_lerp(a: Projection, b: Projection, amount: float) -> Projection:
	return Projection(
		a.x.lerp(b.x, amount),
		a.y.lerp(b.y, amount),
		a.z.lerp(b.z, amount),
		a.w.lerp(b.w, amount))
	

## Apply a matrix to a node.
static func mat_apply(node: Node, mat: Projection, off: Vector4, param_mat := "colormatrix", param_off: String = "colormatrix_offset"):
	if not "material" in node:
		push_error("Can't apply ColorMatrix to node %s." % node)
		return
	
	if not node.material:
		if node is CanvasGroup:
			node.material = load("res://addons/color_matrix/materials/CanvasMatrix_Material.tres")
		else:
			node.material = load("res://addons/color_matrix/materials/CanvasMatrix_ScreenMaterial.tres")
	
	if node.material is ShaderMaterial:
		var material: ShaderMaterial = node.material
		material.set_shader_parameter(param_mat, mat)
		material.set_shader_parameter(param_off, off)

## Creates a Tint matrix.
static func mat_tint(color: Color) -> Projection:
	var r := color.r
	var g := color.g
	var b := color.b
	var a := color.a
	r = 1 - (1 - r) * a
	g = 1 - (1 - g) * a
	b = 1 - (1 - b) * a
	return Projection(
		Vector4(r, 0, 0, 0),
		Vector4(0, g, 0, 0),
		Vector4(0, 0, b, 0),
		Vector4(0, 0, 0, 1 ))

const DESAT1 := Vector3(0.3086, 0.6094, 0.0820)
const DESAT2 := Vector3(0.2126, 0.7152, 0.0722)
const DESAT3 := Vector3(0.299, 0.587, 0.114)
## Creates a Saturation matrix.
static func mat_saturation(value := 0.0, desat := DESAT1) -> Projection:
	var r := desat.x
	var g := desat.y
	var b := desat.z
	var r0 := lerpf(r, 0, value)
	var r1 := lerpf(r, 1, value)
	var g0 := lerpf(g, 0, value)
	var g1 := lerpf(g, 1, value)
	var b0 := lerpf(b, 0, value)
	var b1 := lerpf(b, 1, value)
	return Projection(
		Vector4(r1, g0, b0, 0),
		Vector4(r0, g1, b0, 0),
		Vector4(r0, g0, b1, 0),
		Vector4(0, 0, 0, 1))

#static func mat_matrix_film(amount := 1.0):
	#var r: = pow(1./amount, 3.0/2.0)
	#var g: = pow(1./amount, 4.0/5.0)
	#var b: = pow(1./amount, 3.0/2.0)
	#return Projection(
		#Vector4(r, 0, 0, 0),
		#Vector4(0, g, 0, 0),
		#Vector4(0, 0, b, 0),
		#Vector4(0, 0, 0, 1))
	

# Monochrome
#[Vector4(0.299, 0.587, 0.114, 0),
 #Vector4(0.299, 0.587, 0.114, 0),
 #Vector4(0.299, 0.587, 0.114, 0),
 #Vector4(0, 0, 0, 1)]

#;White to Alpha
#ColorMatrix1=1;0;0;-1;0
#ColorMatrix2=0;1;0;-1;0
#ColorMatrix3=0;0;1;-1;0

#;Polaroid Color
#ColorMatrix1=1.438;-0.062;-0.062;0;0
#ColorMatrix2=-0.122;1.378;-0.122;0;0
#ColorMatrix3=-0.016;-0.016;1.483;0;0
#ColorMatrix5=-0.03;0.05;-0.02;0;1

#{.3f, .3f, .3f, 0, 0},
#new float[] {.59f, .59f, .59f, 0, 0},
#new float[] {.11f, .11f, .11f, 0, 0},
#new float[] {0, 0, 0, 1, 0},
#new float[] {0, 0, 0, 0, 1}

# Sepia
#new float[] {.393f, .349f, .272f, 0, 0},
#new float[] {.769f, .686f, .534f, 0, 0},
#new float[] {.189f, .168f, .131f, 0, 0},
#new float[] {0, 0, 0, 1, 0},
#new float[] {0, 0, 0, 0, 1}

## Creates a Brightness matrix.
static func mat_brightness(value := 0.0) -> Projection:
	return Projection(
		Vector4(1, 0, 0, value),
		Vector4(0, 1, 0, value),
		Vector4(0, 0, 1, value),
		Vector4(0, 0, 0, 1))

## Creates an Opacity matrix.
static func mat_opacity(value := 1.0) -> Projection:
	return Projection(
		Vector4(value, 0, 0, 0),
		Vector4(0, value, 0, 0),
		Vector4(0, 0, value, 0),
		Vector4(0, 0, 0, value))

# value: <0.0 decrease. >1.0 increase.
## Creates a Contrast matrix.
static func mat_contrast(value := 0.0) -> Projection:
	var d := value
	var v := value / -2.0 + .5
	return Projection(
		Vector4(d, 0, 0, v),
		Vector4(0, d, 0, v),
		Vector4(0, 0, d, v),
		Vector4(0, 0, 0, 1))

static func mat_gamma(gamma: float) -> Projection:
	var inv_gamma := gamma#1.0 / gamma
	var pow_gamma := pow(1.0, inv_gamma)
	return Projection(
		Vector4(inv_gamma, 0.0, 0.0, 0.0),
		Vector4(0.0, inv_gamma, 0.0, 0.0),
		Vector4(0.0, 0.0, inv_gamma, 0.0),
		Vector4(0.0, 0.0, 0.0, 1.0))

static func bnw(t: float) -> Projection:
	return Projection(
		Vector4(t, t, t, 0),
		Vector4(t, t, t, 0),
		Vector4(t, t, t, 0),
		Vector4(0.0, 0.0, 0.0, 1)
		#Vector4(0.5, 0.5, 0.5, 0),
	#Vector4(0.5, 0.5, 0.5, 0),
	#Vector4(0.5, 0.5, 0.5, 0),
	#Vector4(0, 0, 0, 1)
	)
	#return Projection(
		#Vector4(1.0, 0.0, 0.0, 0.0),
		#Vector4(1.0, 0.0, 0.0, 0.0),
		#Vector4(1.0, 0.0, 0.0, 0.0),
		#Vector4(0.0, 0.0, 0.0, 1.0))
		
		#Vector4(0.0, 0.0, 0.0, 0.0),
		#Vector4(0.0, 0.0, 0.0, 0.0),
		#Vector4(0.0, 0.0, 0.0, 0.0),
		#Vector4(1.0, 1.0, 1.0, 1.0));
	#return Projection(
		#Vector4(1.5, 1.5, 1.5, 0.),
		#Vector4(1.5, 1.5, 1.5, 0.),
		#Vector4(1.5, 1.5, 1.5, 0.),
		#Vector4(-1, -1, -1, 1.0))

## Creates a Hue Shift matrix.
static func mat_hue(degrees := 0.0) -> Projection:
	var radians := deg_to_rad(degrees)
	var c := cos(radians)
	var s := sin(radians)
	var lR := 0.213
	var lG := 0.715
	var lB := 0.072
	var cnr := lR + c * -lR
	var cng := lG + c * -lG
	var cnb := lB + c * -lB
	return Projection(
		Vector4(lR + c * (1 - lR) + s * -lR, cng + s * -lG, cnb + s * (1 - lB), 0.0),
		Vector4(cnr + s * 0.143, lG + c * (1 - lG) + s * 0.140, cnb + s * -0.283, 0.0),
		Vector4(cnr + s * (-(1 - lR)), cng + s * lG, lB + c * (1 - lB) + s * lB, 0.0),
		Vector4(0, 0, 0, 1.0))

# value: 1.0 == full. 0.0 == no invert.
static func mat_invert(value := 0.0) -> Projection:
	var d = 1.0 - 2. * value
	return Projection(
		Vector4(d, 0, 0, value),
		Vector4(0, d, 0, value),
		Vector4(0, 0, d, value),
		Vector4(0, 0, 0, 1))

#static func mat_tone(desaturation := 0.2, toned := 0.15, light := Color("#FFE580"), dark := Color("#338000")) -> Projection:
	#var lr := light.r
	#var lg := light.g
	#var lb := light.b
	#var dr := dark.r
	#var dg := dark.g
	#var db := dark.b
	#return Projection(
		#Vector4(0.3, 0.59, 0.11, 0),
		#Vector4(lr, lg, lb, desaturation),
		#Vector4(db, db, db, toned),
		#Vector4(lr - dr, lg - dg, lb - db, 0))


static func mat_temp(v := 0.) -> Projection:
	return Projection(
		Vector4(1.+v, 0., 0., 0.),
		Vector4(0., 1., 0, 0.),
		Vector4(0., 0., 1.-v, 0.),
		Vector4(0., 0., 0., 1.))

## Matrix for blending a grayscale between two colors for the dark and light.
static func mat_duotone(color1 := Color.BLACK, color2 := Color.WHITE) -> Projection:
	var r1 := color1.r
	var g1 := color1.g
	var b1 := color1.b
	var r2 := color2.r
	var g2 := color2.g
	var b2 := color2.b
	return Projection(
		Vector4((r2 - r1), 0, 0, r1),
		Vector4((g2 - g1), 0, 0, g1),
		Vector4((b2 - b1), 0, 0, b1),
		Vector4(0, 0, 0, 1))
		#Vector4((r2 - r1), 0, 0, r1),
		#Vector4(0, (g2 - g1), 0, g1),
		#Vector4(0, 0, (b2 - b1), b1),
