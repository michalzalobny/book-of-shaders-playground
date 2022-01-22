//Circle shader code from: https://www.shadertoy.com/view/ltBXRc (Created by phil)

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

    len += variation(diff, vec2(0.0, 1.0), 4.0, 10.0);
    len -= variation(diff, vec2(1.0, 0.0), 4.0, 10.0);
    
    float circle = smoothstep(rad-width, rad, len) - smoothstep(rad, rad+width, len);
    return vec3(circle);
}

vec2 brick(vec2 st, float zoom, float speed){
    st *= zoom;

    float onOffTime = mod(speed * uTime, 1.0);
    float onOffTimeM = mod(speed * uTime * 0.5, 1.0) * 2.0;

    //Offset element on even rows (its like using the ternary operator : mod(x, 2.0) < 1.0 ? 0.0 : 1.0;)
    st.x += step(1.0, mod(st.y,2.0)) * onOffTime * step(1.0, onOffTimeM);
    st.x -= (1.0 - step(1.0, mod(st.y,2.0))) * onOffTime * step(1.0, onOffTimeM);

    st.y += step(1.0, mod(st.x,2.0)) * onOffTime * (1.0 - step(1.0, onOffTimeM));
    st.y -= (1.0 - step(1.0, mod(st.x,2.0))) * onOffTime * (1.0 - step(1.0, onOffTimeM));
    return fract(st);
}

void main()
{
    vec2 st = vUv;

    // Divide the space in 10
    st = brick(st, 7.0, 0.8);

    // Use a matrix to rotate the space 45 degrees
    st -= vec2(0.5);
    st = rotate2d(PI * 0.25  ) * st;
    st += vec2(0.5);

    vec3 color;
    float radius = 0.3;
    vec2 center = vec2(0.5);

    //paint color circle
    color = paintCircle(st, center, radius, 0.04);

    //color with gradient
    vec2 v = rotate2d(uTime) * st;
    color *= vec3(v.x, v.y, 0.5 - v.x * v.y) + 0.8;

    gl_FragColor = vec4(color, 1.0);
}