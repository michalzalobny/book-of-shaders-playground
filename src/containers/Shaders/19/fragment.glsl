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
    vec2 mouseNormalized;
    mouseNormalized.x = (uMouse.x - (uCanvasRes.x - uPlaneRes.x) * 0.5) / uPlaneRes.x;
    mouseNormalized.y = ((uCanvasRes.y -  uMouse.y) - (uCanvasRes.y - uPlaneRes.y) * 0.5) / uPlaneRes.y;

    float change = (sin(uTime * 0.6) + 1.) / 2.;
    float angle = atan(vUv.x - mouseNormalized.x, vUv.y - mouseNormalized.y); //The values of atan(x,y) go from -PI to PI
    angle /= PI * 2.0 * change;
    angle += 0.5;
    float strength = angle;

    strength = step(0.5,mod(strength * 20.* change , 1.));

    //similar result:
    //float strength = sin(angle * 100.0);

    gl_FragColor = vec4(vec3(strength), 1.0);
}