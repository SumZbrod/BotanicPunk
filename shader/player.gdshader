shader_type canvas_item;
uniform bool dash_horizon;
uniform bool dash_down;
uniform bool dash_up;
uniform float dash_module;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.a == 0. && (dash_horizon || dash_down || dash_up)) {
		vec4 clr = COLOR;
		vec2 uv = UV;
		vec2 uv2 = UV;
		if (dash_horizon) {
			uv.x += .0075;
			uv2.x += .014;
		}
		if (dash_down) {
			uv.y += .09;
			uv2.y += .18;
		}
		if (dash_up) {
			uv.y -= .09;
			uv2.y -= .18;
		}
		vec4 near_pix = texture(TEXTURE, uv);
		vec4 near2_pix = texture(TEXTURE, uv2);
		near_pix *= .5 * dash_module;
		near2_pix *= .25 * dash_module;
		COLOR += near_pix;
		COLOR += near2_pix;
	}
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
