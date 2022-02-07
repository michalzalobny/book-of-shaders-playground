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

    vec3 pct = vec3(vUv.x);

    // pct.r = smoothstep(0.0,0.968, vUv.x);
    pct.g = sin(vUv.x*PI);
    // pct.b = pow(vUv.x,0.5);

    color = mix(colorA, colorB, pct);

    // Plot transition lines for each channel
    // color = mix(color,vec3(1.0,0.0,0.0),plot(vUv , pct.r));
    color = mix(color,vec3(0.0,1.0,0.0),plot(vUv,pct.g));
    // color = mix(color,vec3(0.0,0.0,1.0),plot(vUv,pct.b));

    gl_FragColor = vec4(color, 1.0);
}