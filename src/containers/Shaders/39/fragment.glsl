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

void main()
{
    vec2 st = vUv;
    float color = step(0.5 + sin(st.y * PI * 2.0) * 0.15, st.x);

    gl_FragColor = vec4(vec3(color), 1.0);
}