shader_type canvas_item;

uniform vec2 center;
uniform float force;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float size;
uniform float thickness;

void fragment() {
	// Called for every pixel the material is visible on.
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaledUV = ( SCREEN_UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask = (1.0 - smoothstep(size - 0.1, size, length(scaledUV - center))) *
	(smoothstep(size - thickness - 0.1, size - thickness, length(scaledUV - center)));

	vec2 disp = normalize(scaledUV - center) * force;
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
	}
