shader_type canvas_item;

uniform vec4 color;
uniform float strength : hint_range(0.0, 1.0);

void fragment() {
	float dist = min(length(UV - vec2(0.5)) * 2.0, 1.0);
	float intensity = pow(10.0, -1.5 * dist) - dist * pow(10.0, -1.5);
	COLOR = vec4(color.xyz, color.w * intensity * strength);
}
