//Ray sphere intersection from: https://www.youtube.com/watch?v=HFPlKQGChpE
uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float remap01(float a, float b, float t){
    return (t-a) / (b-a);
}


void main()
{
    vec2 uv = vUv;
    uv -= 0.5;
    vec3 col = vec3(0.0);

    vec3 ro = vec3(0.0);
    vec3 rd = normalize(vec3(uv.x, uv.y, 1.0));

    vec3 s = vec3(0.0, 0.0, 4.0); //center of sphere
    float r = 1.0; //radius

    float t = dot(s - ro, rd);
    vec3 p = ro + rd * t;
    float y = length(s - p);

    if( y<r){
        float x = sqrt(r*r - y*y);
        float t1 = t-x;
        float t2 = t+x;

        float c = remap01(s.z, s.z - r, t1);

        col = vec3(c);
    }


    gl_FragColor = vec4(col, 1.0);
}