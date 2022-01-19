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
    float r = (distance( vec2(vUv.x, (vUv.y -0.5) * 6.0 + 0.5), vec2(0.5)));

    float color =  max(min(0.15 / r, 1.), 0.);

    gl_FragColor = vec4(vec3(color), 1.0);
}