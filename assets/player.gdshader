shader_type canvas_item;

void fragment(){
	float speed_multiplier = 2.0;

	//COLOR.r += sin(TIME * speed_multiplier) - 1.0;
	COLOR.b = sin(TIME * speed_multiplier) * 25.0 - 1.0;
}
//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
