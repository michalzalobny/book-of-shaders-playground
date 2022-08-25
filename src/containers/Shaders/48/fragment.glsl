//Based on : https://www.youtube.com/watch?v=PBxuVlp7nuM

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

float DrawPoint (vec3 ro, vec3 rd, vec3 p){
    float d = DistLine(ro, rd, p); //distance between a point and a ray direction shooted from camera
    return d = smoothstep(0.06, 0.05, d);
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;

    float zoom = 1.0;
    vec3 ro = vec3(sin(uTime) * 4., 2.0, cos(uTime) * 4.); //ray origin (camera position)
    vec3 lookAt = vec3(0.0); //center of a cube
    vec3 f = normalize(lookAt - ro);//forward vector
    vec3 r = normalize(cross(vec3(0.0, 1.0, 0.0), f));//right vector is the cross product of world UP vector and forward vector f
    vec3 u = cross(f, r); //Camera up vector

    vec3 c = ro + f*zoom;//center of the screen
    vec3 i = c + uv.x * r + uv.y * u;//intersection point
    vec3 rd = i - ro;

    //Drawing 8 points
    float d = 0.0;
    d += DrawPoint(ro, rd, vec3(-0.5, 0.5, 0.5)); 
    d += DrawPoint(ro, rd, vec3(0.5, 0.5, 0.5));
    d += DrawPoint(ro, rd, vec3(0.5, -0.5, 0.5));
    d += DrawPoint(ro, rd, vec3(-0.5, -0.5, 0.5));
    d += DrawPoint(ro, rd, vec3(-0.5, 0.5, -0.5));
    d += DrawPoint(ro, rd, vec3(0.5, 0.5, -0.5));
    d += DrawPoint(ro, rd, vec3(0.5, -0.5, -0.5));
    d += DrawPoint(ro, rd, vec3(-0.5, -0.5, -0.5));

    gl_FragColor = vec4(vec3(d), 1.0);
}