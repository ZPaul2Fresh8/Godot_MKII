shader_type sky;

uniform vec3 skyColor : source_color;
uniform vec3 horizonColor : source_color;

void sky() {
	float col = clamp(EYEDIR.y / 0.05, 0.0, 1.0);
	vec3 finalColor = mix(horizonColor, skyColor, col);
	COLOR = finalColor * LIGHT0_ENERGY;
}
