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
	float clamped_distance = max(distance, 0);
	float abs_distance = abs(distance);
	float factor = 1.0 - pow(1.0 - abs_distance, 3);
	float inverseFacctor = 1.0 - pow(abs_distance, 2);
	float value = noise(pos.xy * scale);
	vec4 col = compute_insed_color(pos, COLOR.xy * 2.0 - 1.0);

	float intensity = 1.0 - (1.0 - (value * inverseFacctor)) * factor;
	if (distance > 0.0) {
		intensity = intensify(intensity, sharpening);
	}
	// if (distance < 0.0) {
	// 	intensity = min((distance - -1.0) * 1.0, 1.0);
	// 	// intensity = -distance;
	// }
	COLOR = vec4(highlight_color.xyz, intensity);
}


//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
