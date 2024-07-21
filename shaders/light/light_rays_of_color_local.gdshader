shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest_mipmap;

uniform vec2 origin;
uniform float strength_threshold :hint_range(0.0, 1.0) = 0.5;
uniform vec4 color;
uniform float glow_strength : hint_range(0.0, 1.0);
uniform float ray_strength : hint_range(0.05, 0.5);
const int iterations = 15;

void vertex() {
}

void fragment() {
	vec2 center = origin / SCREEN_PIXEL_SIZE;
	// vec2 center = vec2(0.5) / SCREEN_PIXEL_SIZE;
	vec2 pixel = SCREEN_UV.xy / SCREEN_PIXEL_SIZE;
	vec2 current = vec2(pixel);
	vec2 direction = normalize(center - pixel);
	// vec2 step = direction * step_size;

	float distance_to_center = length(pixel - center);

	float squared_length_color = dot(color.xyz, color.xyz);

	// int iterations = int(length(target - center) / step_size);

	float travelled = 0.0;
	float last_step_size = 1.0;
	float add_strength = 0.0;
	int i = 0;
	while (i < iterations) {
		float distance = length(current - pixel);
		vec4 value = textureLod(screen_texture, current * SCREEN_PIXEL_SIZE, (last_step_size - 1.0) * 0.0 + 1.0);
		// vec4 value = texture(screen_texture, current * SCREEN_PIXEL_SIZE);

		float color_intensity = dot(value.xyz, color.xyz) / squared_length_color;
		if (color_intensity > 0.8) {
			add_strength += color_intensity * 5.0 * ray_strength * last_step_size / max(distance, 1.0);
		}
		// last_step_size = min(last_step_size + 0.3 + travelled * 0.03, 0.2 * (distance_to_center - travelled));
		last_step_size = min(pow(last_step_size, 10.0) + 0.1, 0.1 * (distance_to_center - travelled));
		// last_step_size = min(last_step_size + 1.0, 0.1 * (distance_to_center - travelled));
		// last_step_size = min(pow(travelled * 0.15, 1.1) * 0.9 + 1.0, 0.3 * (distance_to_center - travelled));
		// last_step_size = 1.0;
		travelled += last_step_size;
		current += direction * last_step_size;
		i++;
	}

	float dist = min(length(UV - vec2(0.5)) * 2.0, 1.0);
	float expected_intensity = pow(10.0, -1.3 * dist) - dist * pow(10.0, -1.3);
	vec4 current_color = texture(screen_texture, SCREEN_UV);
	float current_intensity = min(dot(current_color.xyz, normalize(color.xyz)) / length(color.xyz), expected_intensity);
	add_strength = min(add_strength, expected_intensity - current_intensity);

	// COLOR = texture(screen_texture, SCREEN_UV) + vec4(add_color.xyz, 0.0);
	COLOR = current_color + vec4(color.xyz * add_strength, 0.0);
	// COLOR = vec4(color.xyz * current_intensity, 0.0);
	// COLOR = vec4(vec3(current_intensity), 1.0);
	// COLOR = vec4(current_color, 1.0);
	// COLOR = vec4(UV.xy, 0.0, 1.0);
	// COLOR = textureLod(screen_texture, SCREEN_UV, 3.0);
	// COLOR = vec4(texture(screen_texture, SCREEN_UV).xy, 1.0, 1.0);
}
