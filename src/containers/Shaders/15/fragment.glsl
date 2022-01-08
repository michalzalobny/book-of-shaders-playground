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
    float verticalP = floor(vUv.x * 10.) * 0.1 + 0.1;
    float horizontalP = floor((vUv.y + vUv.x * 0.5) * 10.) * 0.1 + 0.1;
    vec2 gridUv = vec2(verticalP, horizontalP);

    float color = random(gridUv);

    gl_FragColor = vec4(vec3(color), 1.0);
}