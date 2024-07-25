shader_type spatial;

// Right now this looks pretty ass needs to have the smoke stay behind while moving which is not practical for this jam
void vertex() {
	VERTEX.x += sin(TIME + VERTEX.y) * 0.5 * (VERTEX.y + 2.0 - 1.0);
}

void fragment() {
	ALPHA = UV.y;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
