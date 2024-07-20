shader_type canvas_item;

#include "res://shaders/terrain/polygon_inside.gdshaderinc"

varying vec2 pos;

void vertex() {
	pos = VERTEX.xy;
}

void fragment() {
	vec4 c = compute_insed_color(pos, COLOR.xy * 2.0 - 1.0);
	COLOR = c;
}
