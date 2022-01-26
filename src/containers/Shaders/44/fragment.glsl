uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

struct ray {
    vec3 o, d; //structure of vector with origin and direction
}

ray GetRay(vec2 uv, vec3 camPost, vec3 lookAt, float zoom){
    
}

void main()
{
    vec3 campPos = vec3(0.0, 0.2, 0.0);
    vec3 lookAt = vec3(0.0, 0.2, 1.0);

    gl_FragColor = vec4(vec3(color), 1.0);
}