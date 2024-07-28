shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float dist = min(length(UV - vec2(0.5)) * 2.0, 1.0);
	float intensity = 1.0 - dist * dist;
	COLOR = vec4(vec3(0.0), intensity);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
