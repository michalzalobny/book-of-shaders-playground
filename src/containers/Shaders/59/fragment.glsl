//Gif based on art of code video : https://www.youtube.com/watch?v=cQXAbndD5CQ

uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float Xor(float a, float b){
    return a * (1.0 - b) + b*(1.0-a);
}

void main()
{
    vec2 uv = vUv;
    float amount = 15.0;
    uv.y -= (0.5 + 1.0 / amount * 0.5);
    uv.x -= (0.5 - 1.0 / amount * 0.5);
    float a = PI * 0.5; //angle;
    float c= cos(a);
    float s= sin(a);
    uv*= mat2(c,-s,s,c);
    uv *= amount;
    
    vec3 col = vec3(0.0);
    vec2 gv = fract(uv) - 0.5;//grid uv
    vec2 id = floor( uv);

    float d = length(gv);
    float m = 0.0;

    float t = uTime;

    for(float y = -1.0; y<=1.0; y++){
        for(float x = -1.0; x<=1.0; x++){
            vec2 offs = vec2(x,y);

            float d = length(gv - offs);
            float dist = length(id + offs) * 0.3;
            float r = mix(0.3, 1.5, sin(dist - t)*0.5 + 0.5);
            m = Xor(m, smoothstep(r, r * 0.95, d));
        }
    }

    // col.rg = gv;
    col += m;

    gl_FragColor = vec4(col, 1.0);
}