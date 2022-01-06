uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

vec3 colorA = vec3(0.149,0.141,0.912);
vec3 colorB = vec3(1.000,0.833,0.224);

float plot (vec2 st, float pct){
    return smoothstep(0.01, 0.0, abs(st.y - pct));
}

void main()
{
    vec3 color = vec3(0.0);

    vec3 pct = vec3(vUv.y);

    float waveMove = -pow(cos((uTime)/2.), 2.);

    pct = vec3(waveMove * 0.6 + pow(cos((PI*(vUv.x - uTime * 0.5 ))/2.), 2.));

    color = mix(colorA, colorB, pct);

    // Plot transition lines for each channel
    color = mix(color, vec3(1., 1., 1.) , plot(vUv , pct.r));
    gl_FragColor = vec4(color, 1.0);
}