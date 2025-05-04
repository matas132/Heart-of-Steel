shader_type canvas_item;

void vertex() {

	if (VERTEX.x > 0.0){
		VERTEX.y += sin(TIME *0.7) * 28.0;
	}

}

void fragment() {
	// Called for every pixel the material is visible on.
}
