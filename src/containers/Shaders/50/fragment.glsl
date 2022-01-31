uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359



void main()
{
    vec2 uv = vUv;
    uv -= 0.5;

    vec2 st = vec2(atan(uv.x, uv.y), length(uv));

    float speed = uTime * 0.5;
    float skew = st.y * sin(speed);

    uv = vec2(st.x / (2.0 * PI) + 0.5 * speed + skew, st.y);

    float x = uv.x * 6.0;
    float m = min(fract(x), fract(1.0 - x));

    float c = smoothstep(0.0, 0.05, m * 0.6 + 0.2  -uv.y);

    gl_FragColor = vec4(vec3(c), 1.0);
}