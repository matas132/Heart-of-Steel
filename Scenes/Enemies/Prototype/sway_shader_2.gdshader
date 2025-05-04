shader_type canvas_item;

void vertex() {
	if (VERTEX.x <= 0.0){
		VERTEX.y += cos(TIME *0.7) * 28.0;
	}
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
