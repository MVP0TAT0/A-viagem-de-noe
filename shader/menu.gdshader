shader_type canvas_item;

uniform float blur_size = 1;
uniform vec4 glow_color = vec4(1.0, 1.0, 1.0, 0.5);

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    vec4 glow = vec4(0.0);
    
    for (float x = -blur_size; x <= blur_size; x++) {
        for (float y = -blur_size; y <= blur_size; y++) {
            vec2 offset = vec2(x, y) / vec2(textureSize(TEXTURE, 0));
            glow += texture(TEXTURE, UV + offset) * 0.05;
        }
    }

    COLOR = col + glow_color * glow.a;
}
