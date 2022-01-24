uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float random(vec2 st)
{
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

float stroke (float x, float s, float w){
    float d = step(s, x + w * 0.5) - step(s, x - w * 0.5);
    return clamp(d, 0.0, 1.0);
}

float fill(float x, float size){
    return 1. - step(size, x);
}

float circleSDF(vec2 st){
    return length(st - 0.5) * 2.0;
}

float rectSDF(vec2 st, vec2 s){
    st = st * 2.0 - 1.0;
    return max( abs(st.x/s.x), abs(st.y/s.y));
}

float spiralSDF(vec2 st, float t){
    st -= 0.5;
    float r = dot(st,st  );
    float a = atan(st.y, st.x);
    return abs(sin(fract(log(r)* t + a * 0.159)));
}

void main()
{
    vec2 st = vUv;
    float color;

    color += step(0.5, spiralSDF(st, .13));
    

    gl_FragColor = vec4(vec3(color), 1.0);
}