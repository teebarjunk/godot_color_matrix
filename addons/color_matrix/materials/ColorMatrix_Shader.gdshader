shader_type canvas_item;

uniform lowp mat4 colormatrix = mat4(vec4(1.0, 0.0, 0.0, 0.0),
									vec4(0.0, 1.0, 0.0, 0.0),
									vec4(0.0, 0.0, 1.0, 0.0),
									vec4(0.0, 0.0, 0.0, 1.0));
uniform vec4 colormatrix_offset = vec4(0.0, 0.0, 0.0, 0.0);
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blend : hint_range(0.0, 1.0, 0.01) = 1.;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR *= screen * colormatrix;
	COLOR += colormatrix_offset;
	COLOR = mix(screen, COLOR, blend);
}

