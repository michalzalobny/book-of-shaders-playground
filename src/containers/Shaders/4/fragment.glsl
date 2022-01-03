uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;


float plot(vec2 st) {    
    return smoothstep(0.02, 0.0, abs(st.x-st.y)); //Used to turn elements on or off => goes from 0 to 1 smoothly in the range of the first and second argument
}

void main()
{
    vec2 st = vUv;
    float pct = plot(st);
    vec3 col = (1. - pct ) * vec3(st.x) + vec3(0., pct, 0.);
    gl_FragColor = vec4(col, 1.0);
}