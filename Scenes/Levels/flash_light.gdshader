shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	const float max_glow = 0.08;
	const float glow_speed = 2.8;
	const float glow = 0.2;
	float sin_amount = sin(TIME*glow_speed)* max_glow; 
	COLOR.rgb = vec3(COLOR.r +glow + sin_amount, COLOR.g + glow+ sin_amount , COLOR.b + glow + sin_amount);
	
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
