//Twisted toroid
//Based on : https://www.youtube.com/watch?v=rA9NmBRqfjI

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define MAX_STEPS 100 //integer
#define MAX_DIST 100.0 //float
#define SURF_DIST 0.001

//returns distance of a point p to a torus
float dTorus(vec3 p, vec2 r){
    float x = length(p.xz) - r.x;
    return length(vec2(x, p.y)) - r.y;
}

float GetDist(vec3 p) {
    float td = dTorus(p - vec3(0.0, 0.0, 0.0), vec2(1.0, 0.75));
    return td;
}

void main()
{
    vec2 uv = vUv;
    uv -= 0.5;
    float t = uTime * 0.4;

    uv *= mat2(cos(t), -sin(t), sin(t), cos(t));

    vec3 col = vec3(0.0);

    vec3 ro = vec3(0.0, 0.0, -1.0); //ray origin (camera position)
    vec3 lookAt = mix(vec3(0.0), vec3(-1.0, 0.0, -0.5), sin(t * 1.65) * 0.5 + 0.5);
    float zoom = mix(0.35, 0.7, sin(t * 2.0) * 0.5 + 0.5);

    vec3 f = normalize(lookAt - ro);
    vec3 r = normalize(cross(vec3(0.0, 1.0, 0.0), f));
    vec3 u = normalize(cross(f, r));
    vec3 c = ro + f * zoom;
    vec3 i = c + uv.x * r + uv.y * u;
    vec3 rd = normalize(i-ro);

    float dS = 0.0;
    float dO = 0.0;
    vec3 p = vec3(0.0);

    for(int i = 0; i<MAX_STEPS; i++){
        p = ro + rd * dO; 
        dS = -GetDist(p);
        dO += dS;
        if(dO > MAX_DIST || dS < SURF_DIST) break;
    }

    float m = 0.0;

    if(dS < 0.001){
        float x = atan(p.x, p.z) + t;
        float y = atan(length(p.xz) - r.x, p.y);
        float bands = sin(y * 10.0 + x * 20.0);
        float ripples = sin((x * 10.0 - y * 30.0) * 3.0) * 0.5 + 0.5;
        float waves = sin(x * 2.0 - y * 6.0 + t * 20.0);
        float b1 = smoothstep(-0.2, 0.2, bands);
        float b2 = smoothstep(-0.2, 0.2, bands - 0.5);

        m = b1 * (1.0 - b2);

        m = max(m, ripples * b2 * max(0.0, waves));
        m += max(0.0, waves * 0.3*b2);
    }

    col = mix(vec3(0.078, 0.376, 1.0), vec3(0.698, 0.941, 0.960), m);

    
    gl_FragColor = vec4(col, 1.0);
}