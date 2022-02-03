//Noise from https://www.youtube.com/watch?v=zXsWftRdsvU

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359


float N21 (vec2 p){
    return fract(sin(p.x * 100.0 + p.y * 657.0) * 5647.0);
}

float SmoothNoise(vec2 uv){
    vec2 lv = fract(uv);
    vec2 id = floor(uv);

    lv = lv * lv * (3.0 - 2.0 * lv); //3x^2 - 2x^3

    float bl = N21(id);
    float br = N21(id + vec2(1.0, 0.0));
    float b = mix(bl, br, lv.x);

    float tl = N21(id + vec2(0.0, 1.0));
    float tr = N21(id + vec2(1.0, 1.0));
    float t = mix(tl, tr, lv.x);

    return mix(b, t, lv.y);
}

float SmoothNoise2(vec2 uv){
    float c = SmoothNoise(uv * 4.0);
    c += SmoothNoise(uv * 8.0) * 0.5;
    c += SmoothNoise(uv * 16.0) * 0.25;
    c += SmoothNoise(uv * 32.0) * 0.125;
    c += SmoothNoise(uv * 65.0) * 0.0625;

    return c /= 1.9375; // (sum of all possible maximum values)so that it's always between 0 - 1
}

void main()
{
    vec2 uv = vUv;

    uv += uTime * 0.1;
    float c = SmoothNoise2(uv);

    vec3 col = vec3(c);

    

    gl_FragColor = vec4(col, 1.0);
}