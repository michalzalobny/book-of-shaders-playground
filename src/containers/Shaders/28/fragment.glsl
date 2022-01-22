//Shader code inspiration from: https://www.shadertoy.com/view/ltBXRc (Created by phil)

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

mat2 rotate2d(float angle){
    return mat2(cos(angle),-sin(angle),
                sin(angle),cos(angle));
}

float variation(vec2 v1, vec2 v2, float strength, float speed) {
	return sin(
        dot(normalize(v1), normalize(v2)) * strength + uTime * speed
    ) / 100.0;
}

vec3 paintCircle (vec2 uv, vec2 center, float rad, float width) {
    
    vec2 diff = center-uv;
    float len = length(diff);

    len += variation(diff, vec2(0.0, 1.0), 5.0, 2.0);
    len -= variation(diff, vec2(1.0, 0.0), 5.0, 2.0);
    
    float circle = smoothstep(rad-width, rad, len) - smoothstep(rad, rad+width, len);
    return vec3(circle);
}

void main()
{
    vec3 color;
    float radius = 0.25;
    vec2 center = vec2(0.5);

    //paint color circle
    color = paintCircle(vUv, center, radius, 0.02);

    //color with gradient
    vec2 v = rotate2d(uTime) * vUv;
    color *= vec3(v.x, v.y, 1.2-v.y*v.x);

    //paint white circle
    color += paintCircle(vUv, center, radius, 0.01);
	gl_FragColor = vec4(color, 1.0);
}