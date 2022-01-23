uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359

float random (in float x) {
    return fract(sin(x)*1e4);
}

float randomSerie(float x, float freq) {
    return step(0.2, random(floor(x*freq)));
}

void main()
{
    vec2 st = vUv;
    st.y = st.y * 2.0;

    vec2 ipos = floor(st);  // integer
    vec2 fpos = fract(st);  // fraction

    st = fract(st);

    float isTop = step(1.0, ipos.y);

    float freq1 = 0.3 * uTime * isTop;
    float freq2 = 0.3 * uTime * (1.0 - isTop);

    float color =randomSerie(st.x + 50.0 * isTop - freq1 + freq2 , 50.0);

    gl_FragColor = vec4(vec3(color), 1.0);
}