
#include "res://shaders/noise.gdshaderinc"

uniform vec4 color;
uniform vec4 highlight_color;

float fractal(vec2 pos) {
	vec2 new_pos = pos + vec2(
		noise(pos * 0.05 + vec2(926.0, 195.0)),
		noise(pos * 0.05 + vec2(245.0, 94.0))
	) * 50.0;
	return noise(new_pos * 0.02 + vec2(245.0, 195.0));
}

float sample_height(vec2 pos) {
	return noise(pos * 0.002) * 0.7
		+ noise(pos * 0.02 + vec2(245.0, 195.0)) * 0.2
		+ fractal(pos) * 0.1;
}

vec4 compute_insed_color(vec2 pos, vec2 normal) {
	float height00 = sample_height(pos);
	float height01 = sample_height(pos + vec2(0.0, 20.0));
	float height10 = sample_height(pos + vec2(20.0, 0.0));
	vec3 height_normal = normalize(vec3(vec2(height00 - height10, height00 - height01) * 15.0, 1.0));

	float highlight_strength = max(0, dot(normal, height_normal.xy));
	vec4 base_color = color + (highlight_color - color) * highlight_strength;
	return base_color;
}
