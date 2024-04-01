shader_type canvas_item;

uniform lowp mat4 colormatrix = mat4(vec4(1.0, 0.0, 0.0, 0.0),
									vec4(0.0, 1.0, 0.0, 0.0),
									vec4(0.0, 0.0, 1.0, 0.0),
									vec4(0.0, 0.0, 0.0, 1.0));
uniform vec4 colormatrix_offset = vec4(0.0, 0.0, 0.0, 0.0);

void fragment() {
	COLOR *= colormatrix;
	COLOR += colormatrix_offset;
}

