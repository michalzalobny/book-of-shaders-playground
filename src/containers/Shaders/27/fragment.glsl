uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

//The way of drawing a circle from the book of shaders (two options)
// float circle( vec2 st, float radius){
//     vec2 stC = st - vec2(0.5);
//     return step(radius, dot(stC,stC) * 4.);
//     return smoothstep(radius-(radius*0.01),
//                         radius+(radius*0.01),
//                         dot(stC,stC)*4.0);
// }

//The most accurate way of drawing a circle
float circle( vec2 st, float radius){
    vec2 stC = st - vec2(0.5);
    return 1. - step(radius , length(stC));
}

void main()
{
    vec2 st = vUv;
    vec3 color;
    st*= 5.0 ;
    st = fract(st);
    float c1 = circle(st, 0.2);
    color = vec3(c1);
    gl_FragColor = vec4(color, 1.0);
}