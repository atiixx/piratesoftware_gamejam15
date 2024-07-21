shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;

// const float sample_distance = 100.0;
// const float step_size = 1.0;
// const int iterations = int(sample_distance / step_size);
const int iterations = 30;

void vertex() {
}

void fragment() {
	vec2 center = SCREEN_UV.xy / SCREEN_PIXEL_SIZE + (vec2(0.5) - UV.xy) / TEXTURE_PIXEL_SIZE.xy;
	// vec2 center = vec2(0.5) / SCREEN_PIXEL_SIZE;
	vec2 pixel = SCREEN_UV.xy / SCREEN_PIXEL_SIZE;
	vec2 current = vec2(pixel);
	vec2 direction = normalize(center - pixel);
	// vec2 step = direction * step_size;

	float distance_to_center = length(pixel - center);

	// int iterations = int(length(target - center) / step_size);

	float travelled = 0.0;
	float last_step_size = 1.0;
	vec4 add_color = vec4(0.0);
	int i = 0;
	while (i < iterations && travelled < distance_to_center) {
		float distance = length(current - pixel);
		vec4 value = textureLod(screen_texture, current * SCREEN_PIXEL_SIZE, (last_step_size - 1.0) * 0.2 + 1.0);
		if (length(value.xyz) > 0.9) {
			add_color += pow(value, vec4(3.0)) * 0.2 * last_step_size / max(distance, 2.0);
		}
		// last_step_size = min(pow(travelled * 0.15, 1.1) * 0.9 + 1.0, 0.3 * (distance_to_center - travelled));
		// last_step_size = 1.0;
		last_step_size = min(travelled * 0.1 + 1.0, 0.3 * (distance_to_center - travelled));
		travelled += last_step_size;
		current += direction * last_step_size;
		i++;
	}

	add_color = min(add_color, vec4(1.0));

	COLOR = texture(screen_texture, SCREEN_UV) + vec4(add_color.xyz, 0.0);
	// COLOR = vec4(UV.xy, 0.0, 1.0);
	// COLOR = textureLod(screen_texture, SCREEN_UV, 3.0);
	// COLOR = vec4(texture(screen_texture, SCREEN_UV).xy, 1.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
