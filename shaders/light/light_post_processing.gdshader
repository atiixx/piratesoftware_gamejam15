shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;

const float sample_distance = 100.0;
const float step_size = 1.0;
const int iterations = int(sample_distance / step_size);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 center = vec2(0.5) / SCREEN_PIXEL_SIZE;
	vec2 pixel = SCREEN_UV.xy / SCREEN_PIXEL_SIZE;
	vec2 current = vec2(pixel);
	vec2 direction = normalize(center - pixel);
	vec2 step = direction * step_size;

	float distance_to_center = length(pixel - center);

	// int iterations = int(length(target - center) / step_size);

	float travelled = 0.0;
	vec4 add_color = vec4(0);
	int i = 0;
	while (i < iterations && travelled < distance_to_center) {
		float distance = length(current - pixel);
		vec4 value = textureLod(screen_texture, current * SCREEN_PIXEL_SIZE, 1.0);
		if (length(value.xyz) > 0.9) {
			add_color += pow(value, vec4(3.0)) * 0.1 / max(distance, 2.0);
		}
		travelled += step_size;
		current += step;
		i++;
	}

	add_color = min(add_color, vec4(1.0));

	COLOR = texture(screen_texture, SCREEN_UV) + vec4(add_color.xyz, 0.0);
	// COLOR = textureLod(screen_texture, SCREEN_UV, 3.0);
	// COLOR = vec4(texture(screen_texture, SCREEN_UV).xy, 1.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
