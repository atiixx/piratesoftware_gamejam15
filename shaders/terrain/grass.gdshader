shader_type canvas_item;
render_mode world_vertex_coords;


#include "res://shaders/noise.gdshaderinc"

uniform float time;
varying vec2 pos;

void vertex() {
	VERTEX = VERTEX + (noise(vec2(VERTEX.x * 0.005, time * 0.3)) - vec2(0.5)) * UV.x * vec2(30.0, 5.0);
}

void fragment() {
	float intensity = clamp(1.0 - ((abs(UV.y - 0.5) * 2.0 - 0.6) * 2.5), 0.0, 1.0);
	// intensity = intensify(intensity, 20);
	// COLOR = vec4(COLOR.xyz, intensity);
	COLOR = vec4(COLOR.xyz, intensity);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
