uniform float uTime;
uniform vec2 uPlaneRes;
uniform vec2 uCanvasRes;
uniform vec2 uMouse;
uniform float uPixelRatio;

varying vec2 vUv;

#define PI 3.14159265359


vec2 rotate2D(vec2 _st, float _angle){
    _st -= 0.5;
    _st =  mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle)) * _st;
    _st += 0.5;
    return _st;
}

vec2 brick(vec2 st, float zoom, float speed){
    st *= zoom;

    //Offset element on even rows (its like using the ternary operator : mod(x, 2.0) < 1.0 ? 0.0 : 1.0;)
    st.x += step(1.0, mod(st.y,2.0)) * 0.5;

    return fract(st);
}

float box(vec2 st, vec2 center, float width, float smoothEdges){
    vec2 stCenter = st - center;
    //Converts 1 width to a width of the whole st
    width *= 0.5;
    float xEdges = smoothstep(-width, -(width-smoothEdges) ,stCenter.x) - smoothstep(width-smoothEdges, width ,stCenter.x);
    float yEdges = smoothstep(-width, -(width-smoothEdges) ,stCenter.y) - smoothstep(width-smoothEdges, width ,stCenter.y);
    return xEdges * yEdges;
}

void main()
{
    vec2 st = vUv;

    st /= vec2(1.0,0.5);
    // Divide the space in 10
    st = brick(st, 6.0, 0.8);

    // Use a matrix to rotate the space 45 degrees
    st = rotate2D(st, PI * 0.25 * 0. );

    float color = box(st, vec2(0.5), 0.8, 0.01);
    gl_FragColor = vec4(vec3(color), 1.0);
}