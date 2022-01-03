uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

//mix() used for linear interpolation from value a to b using the function : a(1-x) + xb

float plot(vec2 st) {    
    return smoothstep(0.02, 0.0, abs(st.y - st.x)); //Used to turn elements on or off => goes from 0 to 1 smoothly in the range of the first and second argument
}

void main()
{
    vec2 st = vUv;
    st.x -= 0.5; 
    float fork = smoothstep(0.6, 0.8 ,st.y);
    vec3 col = vec3(smoothstep(0.03 * (1.-fork * 0.8), 0., abs(abs(st.x)-0.05 * fork)));
    gl_FragColor = vec4(col, 1.0);
}