uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float plot(vec2 st, float pct){
    return smoothstep( 0.02, 0., abs(st.y - pct));
}

void main()
{
    vec2 st = vUv;

    float y = smoothstep(0.,1.,st.x);
    float pct = plot(st, y);
    
    vec3 color = vec3(y);
    color = (1.0 - pct) * color + pct * vec3 (0.0,1.0,0.0);
    gl_FragColor = vec4(color, 1.0);
}