shader_type canvas_item;

uniform vec2 scroll_speed = vec2(0.02,0.0);
uniform vec2 wave_factor = vec2(0.00,4.0);
uniform vec2 wave_multiplier = vec2(1.00,1.0);
uniform sampler2D viniet;

void fragment(){
	vec2 uv = UV;
	//vec4 depths_texture = texture(TEXTURE,UV);
	
	float uv_y = mod(uv.y - TIME * scroll_speed.y-sin(TIME+uv.x*wave_factor.x)/100.00 * wave_multiplier.y,1.0);
	
	if (uv_y < 0.0){
		uv_y += 1.0;
	}
	
	float uv_x = mod(uv.x - TIME * scroll_speed.x -sin(TIME+uv.y*wave_factor.y)/100.00 * wave_multiplier.x,1.0);
	
	if (uv_x < 0.0){
		uv_x += 1.0;
	}
	vec4 new_texture = texture(TEXTURE,vec2(uv_x,uv_y)); 
	vec4 viniet_texture = texture(viniet,UV);
	
	COLOR = new_texture;
	
}