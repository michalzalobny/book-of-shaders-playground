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

void main()
{
    vec2 st = vUv;
    float color;

    float offset = cos(st.y * PI) * 0.15;

    color += stroke(st.x, 0.395 + offset, 0.05);
    color += stroke(st.x, 0.5 + offset, 0.05);
    color += stroke(st.x, 0.605 + offset, 0.05);

    gl_FragColor = vec4(vec3(color), 1.0);
}