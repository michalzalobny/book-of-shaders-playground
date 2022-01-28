//inspiration source: https://www.youtube.com/watch?v=bigjgiavOM0

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

mat2 rotate2d(float _angle){
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

float circle( vec2 uv, float radius,  vec2 position, float blur){
    uv -= position; 
    float d = length(uv);
    return smoothstep(radius, radius - blur, d);
}


float band(float t, float start, float end, float blur){
    float step1 = smoothstep(start - blur, start + blur, t);
    float step2 = smoothstep(end + blur, end - blur, t);
    return step1 * step2;
}


float rect(vec2 uv, vec2 position, float width, float height, float blur){
    uv -= position;
    float band1 = band(uv.x, -width/2.0, width/2.0, blur);
    float band2 = band(uv.y, -height/2.0, height/2.0, blur);
    return band1 * band2;
}

float remap01 (float a, float b, float t){
    return (t-a) / (b-a);
}

float remap(float a, float b, float c, float d, float t){
    return remap01(a, b, t) * (d-c) + c;
}

void main()
{
    vec2 st = vUv;
    float strength;

    float m = sin(vUv.x * 20. + uTime * 5.5) * 0.04;
    st.y = st.y - m;
    float blur = remap(0.2, 0.8, 0.45, 0.001, st.x); //remaps 0.3 to 0.001 from 0.2 to 0.8 of st.x (<0, 1>)
    blur = pow(blur * 0.9, 0.95 * (sin(uTime) * 0.5 + 0.5 + 0.9));

    strength += rect(st, vec2(0.5), 0.8, 0.003, blur);
    strength = clamp(strength, 0.0, 1.0);

    vec3 col = sin(vec3(.44 * uTime * 0.1, .14 * (30.0 - uTime * 0.4), 0.45) * st.y ) * 0.85 + 0.85;

    strength *= 2.0;
    col = col * strength;

    gl_FragColor = vec4(col, 1.0);
}