
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
		// + noise(pos * 0.05 + vec2(245.0, 195.0)) * 0.1
		+ fractal(pos) * 0.1;
}

vec4 compute_insed_color(vec2 pos, vec2 normal) {
	float height00 = sample_height(pos);
	float height01 = sample_height(pos + vec2(0.0, 20.0));
	float height10 = sample_height(pos + vec2(20.0, 0.0));
	vec3 height_normal = normalize(vec3(vec2(height00 - height10, height00 - height01) * 15.0, 1.0));

	vec3 l = -vec3(normalize(normal), 0.0);
	vec3 n = dot(-l, height_normal) * height_normal;
	vec3 p = l + n;
	vec3 r = n + p;
	float specular = pow(max(dot(r, vec3(0, 0, 1)), 0), 50.0);

	float highlight_strength = max(0, dot(normal, height_normal.xy));
	// if (highlight_strength > 0.3) {
	// 	highlight_strength = 0.5;
	// } else if (highlight_strength > 0.6) {
	// 	highlight_strength = 1.0;
	// } else {
	// 	highlight_strength = 0.0;
	// }
	vec4 base_color = color + (highlight_color - color) * highlight_strength;
	// vec4 with_specular = base_color * (1.0 - specular) + vec4(1.0) * specular;
	// if (specular > 0.4) {
	// 	return (vec4(1.0) + base_color) * 0.5;
	// }
	// return highlight_color * highlight_strength + color * (1 - highlight_strength);
	return base_color;
	// return vec4(vec2(highlight_strength, highlight_strength) * normal, highlight_strength, 1.0);
	// return vec4(normal * 0.5 + vec2(0.5), highlight_strength, 1.0);
	// return vec4(height00, 0.0, highlight_strength, 1.0);
	// return vec4(height_normal, 1.0);
	// return vec4(height00, height00, height00, 1.0);
}
