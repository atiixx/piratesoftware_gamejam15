shader_type canvas_item;

#include "res://shaders/noise.gdshaderinc"

uniform float scale : hint_range(0, 10);
uniform float sharpening : hint_range(1, 10);
uniform vec4 color;
varying vec2 pos;

void vertex() {
	pos = VERTEX.xy;
}

void fragment() {
	float distance = (0.5 - UV.g) * 2.0;
	float clamped_distance = max(distance, 0);
	float factor = 1.0 - pow(1.0 - clamped_distance, 3);
	float inverseFacctor = 1.0 - pow(clamped_distance, 2);
	float value = noise(pos.xy * scale);

	float intensity = 1.0 - (1.0 - (value * inverseFacctor)) * factor;
	intensity = intensify(intensity, sharpening);
	COLOR = vec4(color.xyz, intensity);
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
