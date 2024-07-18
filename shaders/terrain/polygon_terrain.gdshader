shader_type canvas_item;

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

float intensify(float value, float amount) {
	float a = abs((value - 0.5) * 2.0);
	float s = sign(value - 0.5);
	return (1.0 - pow(1.0 - a, amount)) * s * 0.5 + 0.5;
}

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
