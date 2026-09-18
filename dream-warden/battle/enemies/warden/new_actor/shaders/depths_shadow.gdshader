shader_type canvas_item;
uniform vec2 scroll_speed = vec2(0.0,0.0);
uniform sampler2D viniet;

void fragment(){
	vec2 uv = UV;
	//vec4 depths_texture = texture(TEXTURE,UV);
	
	float uv_y = mod(uv.y - TIME * scroll_speed.y,1.0);
	
	if (uv_y < 0.0){
		uv_y += 1.0;
	}
	
	float uv_x = mod(uv.x - TIME * scroll_speed.x,1.0);
	
	if (uv_x < 0.0){
		uv_x += 1.0;
	}
	vec4 new_texture = texture(TEXTURE,vec2(uv_x,uv_y)); 
	vec4 viniet_texture = texture(viniet,UV);
	
	COLOR = new_texture*vec4(0,new_texture.g*2.0,new_texture.r*8.0,(new_texture.r)*1.5*viniet_texture.r);
}