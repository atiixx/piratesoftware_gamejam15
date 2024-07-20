shader_type canvas_item;

#include "res://shaders/terrain/polygon_inside.gdshaderinc"

uniform float scale : hint_range(0, 10);
uniform float sharpening : hint_range(1, 10);
varying vec2 pos;

void vertex() {
	pos = VERTEX.xy;
}

void fragment() {
	float distance = (0.5 - UV.g) * 2.0;
	float abs_distance = abs(distance);
	float factor = 1.0 - pow(1.0 - abs_distance, 3);
	float inverseFacctor = 1.0 - pow(abs_distance, 2);
	float value = noise(pos.xy * scale);

	float intensity = 1.0 - (1.0 - (value * inverseFacctor)) * factor;
	if (distance > 0.0) {
		intensity = intensify(intensity, sharpening);
	}
	COLOR = vec4(highlight_color.xyz, intensity);
}
