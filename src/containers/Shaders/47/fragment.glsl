//Simple 3D renderer in shader
//Based on : https://www.youtube.com/watch?v=dKA5ZVALOhs

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float DistLine(vec3 ro, vec3 rd, vec3 p){ //Calculates the distance between the point p and the direction of the ray
    return length(cross(p - ro, rd)) / length(rd);
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;

    vec3 ro = vec3(0.0, 0.0, -2.0); //ray origin (camera position)
    vec3 rd = vec3(uv.x, uv.y, 0.0) - ro; //ray direction is (intersection point - ray origin)

    vec3 p = vec3(sin(uTime) * 0.45, 0.0,  cos(uTime) * 0.45); //Point we want to display
    float d = DistLine(ro, rd, p); //distance between a point and a ray direction shooted from camera

    d = smoothstep(0.03, 0.02, d);
    gl_FragColor = vec4(vec3(d), 1.0);
}