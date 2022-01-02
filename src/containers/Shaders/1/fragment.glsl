uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;


float getStartXValue(){
    return (uCanvasRes.x - uPlaneRes.x) * 0.5 * uPixelRatio;
}

float getStartYValue(){
    return (uCanvasRes.y - uPlaneRes.y) * 0.5 * uPixelRatio;
}


void main()
{
    vec2 st = gl_FragCoord.xy;
    gl_FragColor = vec4((st.x - getStartXValue()) / uPlaneRes.x , (st.y - getStartYValue()) / uPlaneRes.y, 0.0, 1.0);
}