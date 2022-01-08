uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359


void main()
{
    float verticalP = floor(vUv.x * 10.) * 0.1 + 0.1;
    float horizontalP = floor(vUv.y * 10.) * 0.1 + 0.1;

    float color = horizontalP * verticalP;

    gl_FragColor = vec4(vec3(color), 1.0);
}