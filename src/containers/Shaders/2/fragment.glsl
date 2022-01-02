uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;

varying vec2 vUv;


void main()
{
    vec2 st = uMouse.xy; 
    gl_FragColor = vec4(st.x/uCanvasRes.x ,st.y/uCanvasRes.y, 0.0, 1.0);
}