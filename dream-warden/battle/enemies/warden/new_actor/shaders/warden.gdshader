shader_type spatial;

render_mode cull_disabled;

uniform sampler2D depths;
uniform sampler2D warden_color;

uniform vec4 depth_layer_1_primary : source_color = vec4(0.1,0.1,0.1,1.0);
uniform vec4 depth_layer_1_background : source_color = vec4(0.1,0.1,0.1,1.0);
uniform vec4 depth_layer_2_primary : source_color = vec4(0.1,0.1,0.1,1.0);
uniform vec4 depth_layer_2_background : source_color = vec4(0.1,0.1,0.1,1.0);

uniform vec4 outline_color : source_color = vec4(0.1,0.1,0.1,1.0);

//vec3 depths_layer_1 = vec3(texture(depths,uv_scroll_1).g*0.3,texture(depths,uv_scroll_1).g*0.5,texture(depths,uv_scroll_1).b);
//vec3 depths_layer_2 = vec3(-2.0,texture(depths,uv_scroll_2).g*4.5,texture(depths,uv_scroll_2).b);
	
uniform float scroll_speed =0.1;
//uniform float band_1_factor = 0.000001;
void vertex() {
	// Called for every vertex the material is visible on.
	// Hopefully has a PSX effect to it???? 
	VERTEX = intBitsToFloat(floatBitsToInt(VERTEX));
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 normal_sample = texture(warden_color,UV).rgb;
	
	float normal_facing = dot(NORMAL, VIEW);
	
	vec2 uv_scroll_1 = UV + scroll_speed * TIME;
	vec2 uv_scroll_2 = UV - scroll_speed * TIME;
	
	vec3 main_warden_color = texture(warden_color,UV).rgb;
	
	vec3 depths_layer_1 = mix(depth_layer_1_background.rgb,depth_layer_1_primary.rgb,texture(depths,uv_scroll_1).b);
	//vec3 depths_layer_2 = vec3(-2.0,texture(depths,uv_scroll_2).g,texture(depths,uv_scroll_2).b);
	vec3 depths_layer_2 = mix(depth_layer_2_background.rgb,depth_layer_2_primary.rgb,texture(depths,uv_scroll_2).b);
	
	vec3 depths_layer_mix = mix(depths_layer_1,depths_layer_2,0.2);
	vec3 warden_depths_color = mix(main_warden_color,depths_layer_mix,depths_layer_mix*0.7);
	float band = normal_facing * 4.0;
	//float band_2 = normal_facing * 9.0;
	
	vec3 color = warden_depths_color;
	vec3 mask = vec3(0,0,0);
	
	vec3 overlay_color = vec3(0,0,0);
	
	if (band <= 2.0){
		float multiply_factor = 4.0;
		//mask = vec3(band*0.0,band*0.0,band*multiply_factor);
		//ALBEDO = vec3(band,band,band);multiply_factor
		//EMISSION = vec3(band,band,band);
		overlay_color = mix(outline_color.rgb,vec3(0.0,0.0,0.0),-0.01/(band-2.01));
	}
	
	color = mix(color,overlay_color,overlay_color.b*2.0);
	
	ALBEDO = color;
	EMISSION = color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
