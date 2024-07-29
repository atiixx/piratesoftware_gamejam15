shader_type canvas_item;

uniform vec4 color;
uniform float fall_off : hint_range(0.0, 5.0) = 2.0;

void fragment() {
	float dist = min(length(UV - vec2(0.5)) * 2.0, 1.0);
	float intensity = 1.0 - pow(dist, fall_off);
	COLOR = vec4(color.xyz, color.w * intensity);
}
